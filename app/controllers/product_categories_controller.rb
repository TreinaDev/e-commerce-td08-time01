class ProductCategoriesController < ApplicationController

  def index
    @branches_array = BranchesOrganizer.get_branches

  end
end