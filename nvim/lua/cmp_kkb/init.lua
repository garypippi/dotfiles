local source = {}

source.get_keyword_pattern = function()
    return [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\%(\w\|á\|Á\|é\|É\|í\|Í\|ó\|Ó\|ú\|Ú\)*\%(-\%(\w\|á\|Á\|é\|É\|í\|Í\|ó\|Ó\|ú\|Ú\)*\)*\)]]
end

source.complete = function(self, params, callback)
    callback({
        items = {
            { label = 'hoge', dup = 0}
        },
        isIncomplete = false
    })
  --local opts = self:_validate_options(params)

  --local processing = false
  --local bufs = self:_get_buffers(opts)
  --for _, buf in ipairs(bufs) do
  --  if buf.timer:is_active() then
  --    processing = true
  --    break
  --  end
  --end

  --vim.defer_fn(function()
  --  local input = string.sub(params.context.cursor_before_line, params.offset)
  --  local items = {}
  --  local words = {}
  --  for _, buf in ipairs(bufs) do
  --    for _, word_list in ipairs(buf:get_words()) do
  --      for word, _ in pairs(word_list) do
  --        if not words[word] and input ~= word then
  --          words[word] = true
  --          table.insert(items, {
  --            label = word,
  --            dup = 0,
  --          })
  --        end
  --      end
  --    end
  --  end

  --  callback({
  --    items = items,
  --    isIncomplete = processing,
  --  })
  --end, processing and 100 or 0)
end

return source
