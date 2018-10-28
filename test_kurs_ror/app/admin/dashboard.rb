ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      panel 'Actions' do
        ul do
          li link_to('Add product', new_product_path)
          li link_to('All products', products_path)
        end
      end
    end
  end
end

# Here is an example of a simple dashboard with columns and panels.
#
# columns do
#   column do
#     panel "Recent Posts" do
#       ul do
#         Post.recent(5).map do |post|
#           li link_to(post.title, admin_post_path(post))
#         end
#       end
#     end
#   end
