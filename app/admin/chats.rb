ActiveAdmin.register Chat do
  permit_params :name, :subreddit, :user_id
end
