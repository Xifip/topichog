require 'spec_helper'
require "debugger"


describe "user preference pages" do

  let(:user) { create_logged_in_user }

  describe "edit preferences" do

    before(:each) do
      visit edit_user_preference_path(user)               
    end  
    
    subject{page}
    
    it { should have_selector('title', 
          text: full_title(user.name + '| notification preferences')) }


    describe "with mail preferences set false" do

      before do
        user.user_preference.update_attributes( mail_on_follower_post: false,
                                                mail_on_follower: false,
                                                mail_monthly_update: false,
                                                mail_new_features: false,
                                                mail_on_liker: false)
        visit edit_user_preference_path(user)
      end      

      it { find('input#user_preference_mail_on_follower').should_not be_checked}   
      it { find('input#user_preference_mail_on_follower_post').should_not be_checked}  
      it { find('input#user_preference_mail_monthly_update').should_not be_checked}   
      it { find('input#user_preference_mail_new_features').should_not be_checked}   
      it { find('input#user_preference_mail_on_liker').should_not be_checked}   
      
      describe "set preferences to true" do
        before do
          visit edit_user_preference_path(user) 
          find("input#user_preference_mail_on_follower").set(true)
          find("input#user_preference_mail_on_follower_post").set(true)
          find("input#user_preference_mail_monthly_update").set(true)
          find("input#user_preference_mail_new_features").set(true)
          find("input#user_preference_mail_on_liker").set(true)
        end   
        
        it { find('input#user_preference_mail_on_follower').should be_checked }  
        it { expect User.find_by_id(user.id).user_preference.mail_on_follower.should be false } 
        it "should change the mail preferences to true" do
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_on_follower}.from(false).to(true)
        end
        it "should change the mail preferences to false" do            
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_on_follower_post}.from(false).to(true)
        end
        it "should change the mail preferences to false" do            
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_monthly_update}.from(false).to(true)
        end
        it "should change the mail preferences to false" do            
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_new_features}.from(false).to(true)
        end
        it "should change the mail preferences to false" do            
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_on_liker}.from(false).to(true)
        
        end      
      
      end 
              
    end
        
    describe "with mail preferences set to true" do

      before do
       user.user_preference.update_attributes( mail_on_follower_post: true,
                                                mail_on_follower: true,
                                                mail_monthly_update: true,
                                                mail_new_features: true,
                                                mail_on_liker: true)
        visit edit_user_preference_path(user)
      end      
    
      it { find('input#user_preference_mail_on_follower_post').should be_checked}
      it { find('input#user_preference_mail_on_follower').should be_checked}   
      it { find('input#user_preference_mail_monthly_update').should be_checked}   
      it { find('input#user_preference_mail_new_features').should be_checked}   
      it { find('input#user_preference_mail_on_liker').should be_checked}   

      describe "set preferences to false" do
        before do 
          visit edit_user_preference_path(user)
          find("input#user_preference_mail_on_follower").set(false)
          find("input#user_preference_mail_on_follower_post").set(false)
          find("input#user_preference_mail_monthly_update").set(false)
          find("input#user_preference_mail_new_features").set(false)
          find("input#user_preference_mail_on_liker").set(false)          
        end   
        
        it { find('input#user_preference_mail_on_follower').should_not be_checked }  
        it { expect User.find_by_id(user.id).user_preference.mail_on_follower.should be true } 
        it "should change the mail preferences to false" do
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_on_follower}.from(true).to(false)
        end
        it "should change the mail preferences to false" do  
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_on_follower_post}.from(true).to(false)
        end
        it "should change the mail preferences to false" do            
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_monthly_update}.from(true).to(false)
        end
        it "should change the mail preferences to false" do            
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_new_features}.from(true).to(false)
        end
        it "should change the mail preferences to false" do            
          expect do
            click_button "Update preferences"
          end.to change{User.find_by_id(user.id).user_preference.mail_on_liker}.from(true).to(false)                                      
        end      
      
      end 
                         
    end
    
    describe "with no mail preferences set" do
    
      before do
        user.user_preference.destroy
        visit edit_user_preference_path(user)
      end    
    
      it { find('input#user_preference_mail_on_follower_post').should be_checked}
      it { find('input#user_preference_mail_on_follower').should be_checked}   
      it { find('input#user_preference_mail_monthly_update').should be_checked}   
      it { find('input#user_preference_mail_new_features').should be_checked}   
      it { find('input#user_preference_mail_on_liker').should be_checked}   
      
      it { expect User.find_by_id(user.id).user_preference.mail_on_follower_post.should be true }  
      it { expect User.find_by_id(user.id).user_preference.mail_on_follower.should be true }
      it { expect User.find_by_id(user.id).user_preference.mail_monthly_update.should be true }
      it { expect User.find_by_id(user.id).user_preference.mail_new_features.should be true }
      it { expect User.find_by_id(user.id).user_preference.mail_on_liker.should be true }                        
    end
        
  end  

end
