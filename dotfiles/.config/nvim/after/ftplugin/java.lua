local jdtls = require("jdtls")

local root_dir = jdtls.setup.find_root({ "gradlew", ".git", "mvnw" })

-- mason 2.0 removed Package:get_install_path(); packages live under $MASON
local jdtls_install_dir = vim.fn.expand("$MASON/packages/jdtls")
local java_test_path = vim.fn.expand("$MASON/packages/java-test")
local java_debug_path = vim.fn.expand("$MASON/packages/java-debug-adapter")

local runtimes_dir = vim.fn.expand("~/.config/lsp/java/runtimes")
local runtimes = {}
local java_home
local newest_version = -1

if vim.fn.isdirectory(runtimes_dir) == 1 then
  for name, typ in vim.fs.dir(runtimes_dir) do
    if typ == "directory" or typ == "link" then
      local path = runtimes_dir .. "/" .. name
      table.insert(runtimes, { name = name, path = path })
      local version = tonumber(name:match("(%d+)$"))
      if version and version > newest_version then
        newest_version = version
        java_home = path
      end
    end
  end
end

if not java_home then
  java_home = os.getenv("JAVA_HOME")
  if not java_home or java_home == "" then
    local java_bin = vim.fn.exepath("java")
    if java_bin ~= "" then
      java_home = vim.fn.fnamemodify(java_bin, ":h:h")
    end
  end
end

local lombok_jar = vim.fn.expand("~/.config/lsp/java/lombok.jar")

local bundles = {}

local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")
local java_debug_bundle =
  vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")

vim.list_extend(bundles, java_test_bundle)
vim.list_extend(bundles, java_debug_bundle)

local cmd = { java_home .. "/bin/java" }
if vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(cmd, "-javaagent:" .. lombok_jar)
end
vim.list_extend(cmd, {
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
  jdtls_install_dir .. "/config_" .. (vim.fn.has("mac") == 1 and "mac" or "linux"),
  "-data",
  vim.fn.stdpath("cache") .. "/jdtls/nvim-data/" .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
})

jdtls.start_or_attach({
  root_dir = root_dir,
  on_attach = function()
    jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
  end,
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  cmd = cmd,
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
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
        runtimes = runtimes,
      },
    },
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
})
