class BranchesOrganizer < ApplicationService
  def initialize(); end

  def get_branches
    leaves = get_leaves()
    branches_array = []

    leaves.each do |l|
      branch_array = make_arrays(l)
      branches_array << branch_array
    end

    return branches_array
  end

  private

  def make_arrays(l)
    branch_array = []

    while l.product_category_id != nil
      branch_array << l
      l = l.parent
    end
    branch_array << l
  end

  def get_leaves
    product_category_ids = ProductCategory.select(:product_category_id).where.not(product_category_id: nil)
    leaves = ProductCategory.where.not(id: product_category_ids)
  end
end