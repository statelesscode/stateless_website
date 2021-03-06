require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include SignInHelper

  def setup
    @article = articles(:one)
    @comment = comments(:health)
    @user = users(:author)

  end

  test 'should get index' do
    sign_in @user
    get comments_url
    assert_response :success
    assert_select 'meta', name: 'description', content: 'View the latest comments for the hottest topics on Stateless Code.'
    assert_select 'title', 'Stateless Code Comments'  
    assert_select '#commentsIndexTitle', 'Stateless Code Comments'
    assert_select '.stateless-comment-partial-card', Comment.all.count    
  end

  test 'should get show' do
    sign_in @user
    get comment_url(@comment)
    assert_response :success
  end

  test 'should get edit' do
    sign_in @user
    get edit_comment_url(@comment)
    assert_response :success
    assert_response :success
    assert_select 'meta', name: 'description', content: "Edit Comment by #{@comment.commenter.username} on #{@comment.commentable.title}."
    assert_select 'title', "Edit Comment on #{@comment.commentable.title}"  
    assert_select '#commentsEditTitle', "Edit Comment on #{@comment.commentable.title}"
    assert_select 'form'
    assert_select 'form div', 1    
  end

  test 'should create comment from articles nested path' do
    assert_difference('Comment.count') do
      sign_in users(:krugman)
      post article_comments_path(@article), params: {comment:  
        {body: "Break a window!", article: @article}}
    end
    assert_redirected_to article_path(@article)
    assert_equal 'Comment was successfully created.', flash[:notice]
  end

  test 'should update comment' do
    sign_in @user
    patch comment_url(@comment), params: {id: @comment.id, comment: {body: 'I am updated!'}}
    assert_redirected_to comment_path(@comment)
    assert_equal 'Comment was successfully updated.', flash[:notice]
  end

  test 'should destroy comment from articles nested path' do
    assert_difference('Comment.count', -1) do
      sign_in @user
      delete article_comment_path(@article, @article.comments.where(commenter: @user).last), params: {id: @article.comments.last}
    end
    assert_redirected_to article_path(@article)
    assert_equal 'Comment was successfully destroyed.', flash[:notice]
  end

  test 'should not delete destroy if unauthorized' do
    delete article_comment_path(@article, @article.comments.last), params: {id: @article.comments.last}
    assert_redirected_to new_user_session_path
  end

end
