require 'rex/socket'
require 'rex/io/stream'

###
#
# Tcp
# ---
#
# This class provides methods for interacting with a TCP client connection.
#
###
class Rex::Socket::Tcp < Rex::Socket
	
	SHUT_RDWR = 2
	SHUT_WR   = 1
	SHUT_RD   = 0

	include Rex::IO::Stream

	##
	#
	# Factory
	#
	##

	#
	# Wrapper around the base socket class' creation method that automatically
	# sets the parameter's protocol to TCP
	#
	def self.create_param(param)
		param.proto = 'tcp'

		super(param)
	end

	##
	#
	# Stream mixin implementations
	#
	##

	def write(buf, opts = {})
		return sock.syswrite(buf)
	end

	def read(length = nil, opts = {})
		length = 16384 unless length

		begin
			return sock.sysread(length)
		rescue EOFError
			return nil
		end
	end

	def shutdown(how = SHUT_RDWR)
		return (sock.shutdown(how) == 0)
	end

	def has_read_data?(timeout = nil)
		timeout = timeout.to_i if (timeout)

		return (select([ poll_fd ], nil, nil, timeout) != nil)
	end

end
