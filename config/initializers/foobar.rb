if Rails.env.development?
    Rails.logger.debug "its started! in foobar dev"
end

if Rails.env.test?
    Rails.logger.debug "its started! in foobar test"
end


if Rails.env.production?
    Rails.logger.debug "its started! in foobar production"
end

Thread.new do
	i = 0
	while
		#Rails.logger.debug "Hey testing #{i}"
		i=i+1
		sleep(1)
	end
end