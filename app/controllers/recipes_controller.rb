class RecipesController < ApplicationController

    def index
        user = User.find_by(id: session[:user_id])
        recipes = Recipe.all
        if user
            render json: recipes, include: :user, status: :created
        else
            render json: {errors: ["User not logged in"]}, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
        if user
            recipe= user.recipes.create(recipe_params)
            if recipe.valid?
                render json: recipe, include: :user, status: :created
            else
                render json: {errors: ["Unprocessable"]}, status: :unprocessable_entity
            end
        else
            render json: {errors: ["Invalid user login"]}, status: :unauthorized
        end
    end

    private 

    def recipe_params
        params.permit(:id, :title, :instructions, :minutes_to_complete, :user_id)
    end

end
