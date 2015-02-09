# Zachary Hogan
# 2/9/2015
# This is my MovieData class.  It uses hashes to make the running time much quicker as  there is a lot of searching for data in this class.
# It will load the u.data and read all line, putting all of the valuable information into hashes.  

class MovieData
	require './movie_test'
	# test contains user ratings to movies for a user not listed in the base data
	# I decided to only have this constructor accept one value and that being the name of the data set.  So :u1 or :u
	def initialize(data_set)
		@user_info = Hash.new() # user to array of movies they have seen and what they rated them
		@movie_viewers = Hash.new() # user to array of movies they have seen
		@movie_ratings = Hash.new() # movies to an array of their ratings
		@test_set = [] # this holds all relevant information in .test files
		@predictions = []
		load_data(data_set)
	end

	# This will read in the data from the original ml-100k files 	# and stores them in whichever way it needs to be stored
	# 4 tab-separated items:user_id * movie_id * rating * timestamp 
	# There is definitely a better way to do this, but this fills the hashes and keeps methods under 10 lines of code
	def load_data(data_set)
		if data_set != :u
			load_hashes("#{data_set}.base") # training set
			load_test("#{data_set}.test") # test set
		else
			load_hashes("#{data_set}.data") # training set
		end
	end

	# This will loop through the file and send the lines into the methods that load each hash
	def load_hashes(data_set)
		File.open(data_set, "r") do |f|
			f.each_line do |line|
				@@line_array = line.split(' ')
				load_user_info
				load_movie_viewers
				load_movie_ratings	
			end
		end
	end

	# Loads the user_info hash.  That hash is a user pointed to an array of movies they have seen and what they have rated them
	def load_user_info
		if @user_info.has_key?(@@line_array[0].to_i)
			@user_info[@@line_array[0].to_i][@@line_array[1].to_i] = @@line_array[2].to_i
		else
			@user_info[@@line_array[0].to_i] = {@@line_array[1].to_i => @@line_array[2].to_i}
		end
	end

	# Loads the movie_viewers hash which points from a movie to all users that have viewed that movie
	def load_movie_viewers
		if @movie_viewers.has_key?(@@line_array[1].to_i)
			@movie_viewers[@@line_array[1].to_i].push(@@line_array[0].to_i)
		else
			@movie_viewers[@@line_array[1].to_i] = [@@line_array[0].to_i]
		end
	end

	# Loads the movie_ratings hash which points from a movie to all of its ratings
	def load_movie_ratings
		if @movie_ratings.has_key?(@@line_array[1].to_i)
			@movie_ratings[@@line_array[1].to_i].push(@@line_array[2].to_i)
		else
			@movie_ratings[@@line_array[1].to_i] = [@@line_array[2].to_i]
		end
	end

	# Loads the test set.  My test data is in an array of arrays.  Each inner array is structure with [user, movie, rating]
	def load_test(data_set)
		File.open(data_set, "r") do |f|
			f.each_line do |line|
				@@line_array = line.split(' ')
				@test_set.push([@@line_array[0].to_i, @@line_array[1].to_i, @@line_array[2].to_i])
			end
		end
	end

	# z.rating(u,m) returns the rating that user u gave movie m in the training set, and 0 if user u did not rate movie m
	def rating(user, movie)
		if @user_info[user].has_key?(movie)
			return @user_info[user][movie]
		else
			return 0
		end
	end

	# z.predict(u,m) returns a floating point number between 1.0 and 5.0 as an estimate of what user u would rate movie m
	# I know there are better prediciton algorithms, like k-means, but I didn't have time to look thoroughly into it and I 
	# think this will suffice for this assignment.  It finds the average rating for a particular movie and sets the prediction to that.
	def predict(user, movie)
		print "BEFORE CALLING:  "
		puts Time.now
		return average_of_ratings(@movie_ratings[movie])
	end

	# This finds the average in an array of numbers
	def average_of_ratings(numbers)
		sum = numbers.reduce(:+)
		avg = sum.to_f / numbers.length
	end
	
	# z.movies(u) returns the array of movies that user u has watched
	def movies(user)
		return @user_info[user].keys	
	end

	# z.viewers(m) returns the array of users that have seen movie m
	def viewers(movie_id)
		return @movie_viewers[movie_id]
	end

	# z.run_test(k) runs the z.predict method on the first k ratings in the test set and returns a MovieTest object containing the results.
	# The parameter k is optional and if omitted, all of the tests will be run.
	def run_test(*k)
		if !@test_set.empty?
			error_set = []
			if k.length > 0
				# Using the variable upper_bound makes sure it is either looking at k items in the test set or the entire test set
				upper_bound = k[0]
			else
				upper_bound = @test_set.length - 1
			end
			for i in 0..upper_bound
				predicted_rating = predict(@test_set[i][0], @test_set[i][1])
				print "AFTER CALLING:  "
				puts Time.now
				@predictions.push([@test_set[i][0], @test_set[i][1], @test_set[i][2], predicted_rating])
				error_set.push((@test_set[i][2] - predicted_rating).abs)
			end
			movie_test = MovieTest.new(error_set)
		else
			puts "There is no test set!!!!"
		end
	end

	# I decided to have this method in this class because I thought it made more sense.  The way I see it, movie_test is a tool that really doesn't
	# need to know anything about the movies.  All it does is take in a list of numbers and runs some calculations.  I'd rather only have just this
	# class know what is going on with the why of the data than both.
	def get_test_set_data
		return @predictions
	end
end

movie = MovieData.new(:u1)
movie_test = movie.run_test(10)
puts "Mean of data:"
puts movie_test.mean()
puts

puts "RMS of data:"
puts movie_test.rms()

puts "The entirety of the test_set data:"
print movie.get_test_set_data
puts
