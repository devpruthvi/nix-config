{...}: {
  home.sessionVariables.LLAMA_LOCAL_KEY = "sk-local"; # llama.cpp ignores it; dsh requires a credential

  home.file.".dsh/settings.yaml".text = ''
    llm-pi-ai:
      providers:
        local-llama:
          apiKeyEnv: LLAMA_LOCAL_KEY
          api: openai-completions
          baseURL: http://127.0.0.1:8080/v1
          models:
            - id: "local-qwen"
  '';
}
