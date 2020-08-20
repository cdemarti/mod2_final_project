class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  # GET /answers
  # GET /answers.json
  def index
    if current_user.employee 
      @answers = Answer.all
    else
      redirect_to forbidden_path
    end 
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
        @answer = Answer.all.find(params[:id])
  end

  # GET /answers/new
  def new
    if current_user.employee 
      @answer = current_user.answers.build
    else
      redirect_to forbidden_path
    end 
  end

  # GET /answers/1/edit
  def edit
    if current_user.employee == false 
      redirect_to forbidden_path
    end 
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = current_user.answers.build(answer_params)
    
    respond_to do |format|
      if @answer.save
        @question = Question.find(@answer.question_id)
        @user = User.find(@question.user_id)
        UserMailer.answer_email(@user).deliver
        format.html { redirect_to questions_path, notice: 'Answer was successfully created.' }
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to answers_url, notice: 'Answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def answer_params
      params.require(:answer).permit(:title, :body, :question_id, :user_id)
    end
end
