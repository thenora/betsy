require "test_helper"

describe Review do

  let (:new_review) {
    Review.new(
      title: 'So Good',
      rating: 5,
      description: 'How did I get such a perfect plant',
      merchant_id: merchants(:merchant_1).id
    )
  }
  
  # it "can be instantiated" do
  #   expect(new_user.valid?).must_equal true
  # end

  # it "will have the required fields" do
  #   new_user.save
  #   expect(User.first).must_respond_to :username
  # end

  # it "will not let you create two users with the same username" do
  #   invalid = User.new(username: 'tails')

  #   expect(invalid.valid?).must_equal false
  #   expect(invalid.errors.messages).must_include :username
  #   expect(invalid.errors.messages[:username]).must_equal ["has already been taken"]
  # end

  # describe "relationships" do
  #   before do
  #     Vote.all.each do |vote|
  #       Vote.destroy(vote.id)
  #     end
  #   end
    
  #   it "user can have work" do
  #     new_vote = Vote.create(user_id: User.find_by(username: 'wizard').id, work_id: Work.find_by(title: 'Dark Star').id)

  #     expect(Work.find_by(title: 'Dark Star').votes.count).must_equal 1
  #     expect(new_vote.work).must_be_instance_of Work
  #   end

  #   it "user can have vote" do
  #     new_vote = Vote.create(user_id: User.find_by(username: 'witch').id, work_id: Work.find_by(title: 'Spilt Nuts').id)

  #     expect(User.find_by(username: 'witch').votes.count).must_equal 1
  #     expect(new_vote.user).must_be_instance_of User
  #   end 
  # end

  # describe "validations" do
  #   it "must have a username" do
  #     new_user.username = nil

  #     expect(new_user.valid?).must_equal false
  #     expect(new_user.errors.messages).must_include :username
  #   end
  # end

end
