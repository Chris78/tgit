at_exit do
  require "irb"
  require "drb/acl"
  require "sqlite3"
  require "openssl"
  require "i386-mswin32/digest.so"
  require "i386-mswin32/digest/sha2.so"
  require "digest"
  require "digest/sha2"
end

load "script/server"