local jdtls = require("jdtls")
local mason_registry = require("mason-registry")

local root_dir = jdtls.setup.find_root({ "gradlew", ".git", "mvnw" })

local jdtls_install_dir = mason_registry.get_package("jdtls"):get_install_path()
local java_test_path = mason_registry.get_package("java-test"):get_install_path()
local java_debug_path = mason_registry.get_package("java-debug-adapter"):get_install_path()

local java_home = os.getenv("JAVA_HOME")

local bundles = {}

local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")
local java_debug_bundle =
  vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")

vim.list_extend(bundles, java_test_bundle)
vim.list_extend(bundles, java_debug_bundle)

jdtls.start_or_attach({
  root_dir = root_dir,
  on_attach = function()
    jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
  end,
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  cmd = {
    java_home .. "/bin/java",
    "-javaagent:" .. vim.fn.fnamemodify("~/.config/lsp/java/lombok.jar", ":p"),
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms2g",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(jdtls_install_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    jdtls_install_dir .. "/config_linux",
    "-data",
    vim.fn.stdpath("cache") .. "/jdtls/nvim-data/" .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
  },
  settings = {
    java = {
      format = {
        settings = {
          url = "file://" .. vim.fn.fnamemodify("~/.config/lsp/java/eclipse-java-google-style.xml", ":p"),
          profile = "GoogleStyle",
        },
      },
    },
    eclipse = {
      downloadsources = true,
    },
    signatureHelp = { enabled = true },
    contentProvider = { preferred = "fernflower" },
    completion = {
      favoriteStaticMembers = {
        "org.mockito.Mockito.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      hashCodeEquals = {
        useJava7Objects = true,
      },
      useBlocks = true,
    },
    configuration = {
      runtimes = {
        {
          name = "JavaSE-17",
          path = java_home,
        },
      },
    },
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
})
