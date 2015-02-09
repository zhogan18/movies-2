# Zachary Hogan
# 2/9/2015
# This is my MovieTest class.  I changed it around a little from the instructions but I think it works well.  I turned it into something that doesn't 
# really care what is passed into it as long it is an array of numbers.  Technically, this is not even a class for the movie_data, but rather any data.
class MovieTest

	def initialize(error)
		@error_values = error
	end

	# t.mean returns the average predication error (which should be close to zero)
	def mean
		sum = @error_values.reduce(:+)
		avg = sum.to_f / @error_values.length
	end

	# t.stddev returns the standard deviation of the error
	def stddev
		variance = self.variance()
		standard_deviation = Math.sqrt(variance)	
	end

	#To keep modularity I separated the calculation of variance from the standard deviation.  Once I have the variance, I just find the square root
	#And that is my standard deviation 
	def variance
		avg = self.mean()
		variance = 0.0
		@error_values.each do |x|
		  variance = variance + (x-avg)**2
		end
		variance = variance / (@error_values.length - 1)
	end

	# t.rms returns the root mean square error of the prediction
	def rms
		squared_values = @error_values.map { |value| value**2 } 
		rms = Math.sqrt(squared_values.reduce(:+) / squared_values.length)
	end

	
end



