# frozen_string_literal: true

##
# Handles the Handles (hehehe).
# Parses and formats consistently @harry@example.org alike handles over domains
# and into usenames and domains
class Handle
  attr_reader :username, :domain

  def initialize(username,
                 handle_domain = Roost.config.domain,
                 local_domain = Roost.config.domain)
    @domain = handle_domain
    @local_domain = local_domain
    @username = username
  end

  def self.parse(handle)
    return handle.dup if handle.is_a?(Handle)

    uri = URI.parse("http://#{handle.gsub(/^@/, '')}")
    new(uri.user, uri.host)
  end

  def to_s
    return '' if empty?

    "@#{username}@#{domain}"
  end

  def to_str
    to_s
  end

  ##
  # Sequel extension allows us to pass Handles directly into its API.
  def sql_literal(_dataset)
    "'#{self}'"
  end

  def remote?
    domain != @local_domain
  end

  def empty?
    username.to_s.empty?
  end

  def ==(other)
    other = Handle.parse(other) unless other.respond_to?(:username)

    username == other.username && domain == other.domain
  end
end
