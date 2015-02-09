# The MovieTest object also has several instance methods:
class MovieTest

# t.mean returns the average predication error (which should be close to zero)
# t.stddev returns the standard deviation of the error
# t.rms returns the root mean square error of the prediction
# t.to_a returns an array of the predictions in the form [u,m,r,p]. You can also generate other types of error measures if you want, but we will rely mostly on the root mean square error.
	def initialize(error)
		@error_values = error
	end

	def mean
		sum = @error_values.reduce(:+)
		avg = sum.to_f / @error_values.length
	end

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

	def rms
		squared_values = @error_values.map { |value| value**2 } 
		rms = Math.sqrt(squared_values.reduce(:+) / squared_values.length)
	end

	
end



