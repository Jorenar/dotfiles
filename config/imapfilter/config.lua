local function pass(pw)
  local cmd = "pass " .. pw .. " | head -1"
  local handle = assert(io.popen(cmd, 'r'))
  local output = assert(handle:read('*a'))
  handle:close()
  output = string.gsub(output, '^%s+', '')
  output = string.gsub(output, '%s+$', '')
  output = string.gsub(output, '[\n\r]+', ' ')
  return output
end


IMAP {
  server = "example.com",
  username = "user@example.com",
  password = pass("email/example.com"),
} ["INBOX"]:is_new():match_from('(no.response|spam)@spam.com'):delete_messages()

IMAP {
  server = "example.org",
  username = "user@example.org",
  password = pass("email/example.org"),
} ["INBOX"]:contain_from("mailing@example.org"):delete_messages()
