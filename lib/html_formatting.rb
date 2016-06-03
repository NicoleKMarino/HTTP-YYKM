module HTMLFormatting

  def html_body_message(message)
    return "<html><head></head><body>#{message}</body></html>"
  end

  def html_headers(message)
    return ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{html_body_message(message).length}\r\n\r\n"].join("\r\n")
  end

end
