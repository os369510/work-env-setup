local ok, query = pcall(require, "vim.treesitter.query")
if not ok then
  return
end

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  uxn = "uxntal",
  ts = "typescript",
}

local function node_from_match(match, id)
  local value = match[id]
  if type(value) == "table" then
    return value[1]
  end
  return value
end

local function get_parser_from_markdown_info_string(injection_alias)
  local match = vim.filetype.match { filename = "a." .. injection_alias }
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

local function report_error(str)
  vim.api.nvim_err_writeln(str)
end

local function valid_args(name, pred, count, strict_count)
  local arg_count = #pred - 1

  if strict_count then
    if arg_count ~= count then
      report_error(string.format("%s must have exactly %d arguments", name, count))
      return false
    end
  elseif arg_count < count then
    report_error(string.format("%s must have at least %d arguments", name, count))
    return false
  end

  return true
end

local opts = { force = true }

query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
  if not valid_args("nth?", pred, 2, true) then
    return
  end

  local node = node_from_match(match, pred[2])
  local n = tonumber(pred[3])
  if node and node:parent() and node:parent():named_child_count() > n then
    return node:parent():named_child(n) == node
  end

  return false
end, opts)

query.add_predicate("is?", function(match, _pattern, bufnr, pred)
  if not valid_args("is?", pred, 2) then
    return
  end

  local locals = require "nvim-treesitter.locals"
  local node = node_from_match(match, pred[2])
  local types = { unpack(pred, 3) }

  if not node then
    return true
  end

  local _, _, kind = locals.find_definition(node, bufnr)
  return vim.tbl_contains(types, kind)
end, opts)

query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
  if not valid_args(pred[1], pred, 2) then
    return
  end

  local node = node_from_match(match, pred[2])
  local types = { unpack(pred, 3) }

  if not node then
    return true
  end

  return vim.tbl_contains(types, node:type())
end, opts)

query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
  local node = node_from_match(match, pred[2])
  if not node then
    return
  end

  local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
  local configured = html_script_type_languages[type_attr_value]
  if configured then
    metadata["injection.language"] = configured
  else
    local parts = vim.split(type_attr_value, "/", {})
    metadata["injection.language"] = parts[#parts]
  end
end, opts)

query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
  local node = node_from_match(match, pred[2])
  if not node then
    return
  end

  local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
  metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
end, opts)

query.add_directive("make-range!", function() end, opts)

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
  local id = pred[2]
  local node = node_from_match(match, id)
  if not node then
    return
  end

  local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
  if not metadata[id] then
    metadata[id] = {}
  end
  metadata[id].text = string.lower(text)
end, opts)
