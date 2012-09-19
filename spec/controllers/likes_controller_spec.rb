require 'spec_helper'


describe LikesController do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
    
  let(:liked_post) { FactoryGirl.create(:post, user: other_user, 
    postable: FactoryGirl.create(:project, title: "Foo", summary: "football")) }
    
  before { sign_in user }
  
  describe "creating a like with Ajax" do
    
    it "should increment the Like count" do
      expect do
        xhr :post, :create, like: { liked_id: liked_post.id }
      end.to change(Like, :count).by(1)
    end
    
    it "should respond with success" do
      xhr :post, :create, like: { liked_id: liked_post.id }
      response.should be_success
    end
    
  end
  
  describe "destroying a like with Ajax" do
  
    before { user.like!(liked_post) }
    let(:like) { user.likes.find_by_liked_id(liked_post) }
    
    it "should decrement the Like count" do
      expect do
        xhr :delete, :destroy, id: like.id
      end.to change(Like, :count).by(-1)
    end
    
    it "should respond with success" do
      xhr :delete, :destroy, id: like.id
      response.should be_success
    end
  end
end
