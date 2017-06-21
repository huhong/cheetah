class CheetahException < StandardError
end

class CheetahMessagingException < CheetahException
end

class CheetahAuthorizationException < CheetahMessagingException
end

class CheetahTemporaryException < CheetahMessagingException
end

class CheetahPermanentException < CheetahMessagingException
end
