ActiveAdmin.register Chat do
  permit_params :name, :user_id, :subreddit
end
