ActiveAdmin.register User do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  permit_params :email, :password, :password_confirmation, :role
 
    index do
        column :email
        column :current_sign_in_at
        column :last_sign_in_at
        column :sign_in_count
        column :role
        default_actions
    end
 
    filter :email
 
    form do |f|
        f.inputs "User Details" do
            f.input :email
            f.input :password
            f.input :password_confirmation
            f.input :role, as: :radio, collection: {User: "user", Moderator: "moderator", Administrator: "administrator"}
        end
        f.actions
    end
end
