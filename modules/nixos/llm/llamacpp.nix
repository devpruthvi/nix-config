{pkgs, ...}: let
  llama = pkgs.llama-cpp.override {cudaSupport = true;};

  # 90k-context profiles for 16GB VRAM, offloading first-N FFN layers to CPU.
  profiles = {
    # Q4_K_M, q4 KV, 40 FFN layers on CPU: ~21 tps, ~1GB headroom (best quality).
    q4km = {
      hf-repo = "unsloth/Qwen3.8-27B-GGUF:Q4_K_M";
      no-mmap = true; # better perf when tensors are overridden to CPU
      cache-type-k = "q4_0";
      cache-type-v = "q4_0";
      override-tensor = "blk.([0-9]|[123][0-9]).ffn.*=CPU";
    };
    # IQ3_XXS, q4 KV, 13 FFN layers on CPU: ~29 tps, ~1GB headroom (balanced).
    iq3-balanced = {
      hf-repo = "unsloth/Qwen3.8-27B-GGUF:UD-IQ3_XXS";
      cache-type-k = "q4_0";
      cache-type-v = "q4_0";
      override-tensor = "blk.([0-9]|1[0-2]).ffn.*=CPU";
    };
    # IQ3_XXS, q4 KV, 10 FFN layers on CPU: ~35 tps, ~0.7GB headroom (fastest).
    iq3-fast = {
      hf-repo = "unsloth/Qwen3.8-27B-GGUF:UD-IQ3_XXS";
      cache-type-k = "q4_0";
      cache-type-v = "q4_0";
      override-tensor = "blk.[0-9].ffn.*=CPU";
    };
    # Q4_K_M, q4 KV, 200k ctx, 1 slot, 48 FFN on CPU. MTP needs its own ~800MB
    # draft KV at 200k; small ubatch trims prefill buffer at no gen-tps cost.
    q4km-200k = {
      hf-repo = "unsloth/Qwen3.8-27B-GGUF:Q4_K_M";
      no-mmap = true; # better perf when tensors are overridden to CPU
      cache-type-k = "q4_0";
      cache-type-v = "q4_0";
      ctx-size = 204800;
      parallel = 1;
      ubatch-size = 128;
      override-tensor = "blk.([0-9]|[1-3][0-9]|4[0-7]).ffn.*=CPU";
    };
    # UD-Q4_K_M (Unsloth Dynamic 3.0), q4 KV, 200k ctx: same 16.5GB footprint as
    # Q4_K_M but higher quality-per-bit, so mirrors q4km-200k tuning.
    ud-q4km-200k = {
      hf-repo = "unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_M";
      no-mmap = true; # better perf when tensors are overridden to CPU
      cache-type-k = "q4_0";
      cache-type-v = "q4_0";
      ctx-size = 204800;
      parallel = 1;
      ubatch-size = 128;
      override-tensor = "blk.([0-9]|[1-3][0-9]|4[0-7]).ffn.*=CPU";
    };
    # UD-Q4_K_M, q8 K / q4 V, 200k ctx. Asymmetric KV: K is precision-sensitive
    # so it gets q8 for better long-ctx recall; V stays q4 to bound memory. Costs
    # ~half of full-q8 KV, so an extra FFN layer offloads to CPU to hold headroom.
    ud-q4km-200k-kq8 = {
      hf-repo = "unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_M";
      no-mmap = true; # better perf when tensors are overridden to CPU
      cache-type-k = "q8_0";
      cache-type-v = "q4_0";
      ctx-size = 204800;
      parallel = 1;
      ubatch-size = 128;
      override-tensor = "blk.([0-9]|[1-3][0-9]|4[0-8]).ffn.*=CPU";
      no-mmproj = true;
    };
    # vision
    vision = {
      hf-repo = "unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_M";
      no-mmap = true; # better perf when tensors are overridden to CPU
      cache-type-k = "q4_0";
      cache-type-v = "q4_0";
      ctx-size = 62000;
      override-tensor = "blk.([0-9]|[1-3][0-9]|4[0-8]).ffn.*=CPU";
      no-mmproj = false;
    };
    # Uncensored Q4_K_M, q4 KV, 40 FFN layers on CPU: mirrors q4km tuning.
    uncensored_q4km = {
      hf-repo = "theresa00l/Qwen3.8-27B-Uncensored-FP8-Q4_K_M-GGUF:Q4_K_M";
      no-mmap = true; # better perf when tensors are overridden to CPU
      cache-type-k = "q4_0";
      cache-type-v = "q4_0";
      override-tensor = "blk.([0-9]|[123][0-9]).ffn.*=CPU";
    };
  };

  # profile = profiles.vision; # <- current profile
  profile = profiles.ud-q4km-200k; # <- current profile
in {
  environment.systemPackages = [llama];

  services.llama-cpp = {
    enable = true;
    package = llama;

    settings =
      {
        host = "127.0.0.1";
        port = 8080;
        alias = "local-qwen"; # stable model id for clients across profiles

        no-mmproj = true; # skip vision tower (text/agentic use only)

        n-gpu-layers = 999;
        flash-attn = "on";
        batch-size = 1024;
        ubatch-size = 256;
        ctx-size = 90112;

        spec-type = "draft-mtp"; # multi-token prediction
        spec-draft-n-max = 2;

        temp = 1.0;
        top-k = 20;
        top-p = 0.95;
        min-p = 0.0;

        jinja = true; # tool-calling for agents
      }
      // profile;
  };

  # reasoning_effort default is xhigh (over-thinks); medium is balanced.
  # Passed via env, not settings: the module doesn't systemd-escape args so
  # the JSON's double quotes get stripped from ExecStart.
  systemd.services.llama-cpp.environment.LLAMA_ARG_CHAT_TEMPLATE_KWARGS =
    builtins.toJSON {reasoning_effort = "medium";};
}
