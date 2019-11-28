require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'nav.pagination'
    
    # TO-DO: fix pagination to make this test work 

    # first_page_of_users = User.paginate(page: 1)
    # first_page_of_users.each do |user|
    #   assert_select 'a[href=?]', user_path(user), text: user.name
    #   unless user == @admin
    #    assert_select 'a[href=?]', user_path(user), text: 'delete'
    #  end
    # end

    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
  end

  test "index as non-admin" do
    log_in_as(@other_user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
