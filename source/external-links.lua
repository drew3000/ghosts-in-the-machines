local function add_external_link_attributes(html)
  return html:gsub(
    '<a href="(https?://[^"]+)"',
    '<a href="%1" target="_blank" rel="noopener noreferrer"'
  )
end

function Link(link)
  if link.target:match("^https?://") then
    link.attributes["target"] = "_blank"
    local rel = link.attributes["rel"] or ""
    if not rel:match("%f[%w]noopener%f[%W]") then
      rel = rel == "" and "noopener" or rel .. " noopener"
    end
    if not rel:match("%f[%w]noreferrer%f[%W]") then
      rel = rel .. " noreferrer"
    end
    link.attributes["rel"] = rel
  end
  return link
end

function RawBlock(block)
  if block.format == "html" then
    block.text = add_external_link_attributes(block.text)
  end
  return block
end

function RawInline(inline)
  if inline.format == "html" then
    inline.text = add_external_link_attributes(inline.text)
  end
  return inline
end
