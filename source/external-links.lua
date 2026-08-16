local function add_external_link_attributes(html)
  return html:gsub(
    '<a href="(https?://[^"]+)"',
    '<a href="%1" target="_blank" rel="noopener noreferrer"'
  )
end

function Link(link)
  if link.target:match("^https?://") then
    link.attributes["target"] = "_blank"
    link.attributes["rel"] = "noopener noreferrer"
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
