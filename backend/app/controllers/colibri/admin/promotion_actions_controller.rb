class Colibri::Admin::PromotionActionsController < Colibri::Admin::BaseController
  before_filter :load_promotion, :only => [:create, :destroy]
  before_filter :validate_promotion_action_type, :only => :create

  def create
    @calculators = Colibri::Promotion::Actions::CreateAdjustment.calculators
    @promotion_action = params[:action_type].constantize.new(params[:promotion_action])
    @promotion_action.promotion = @promotion
    if @promotion_action.save
      flash[:success] = Colibri.t(:successfully_created, :resource => Colibri.t(:promotion_action))
    end
    respond_to do |format|
      format.html { redirect_to colibri.edit_admin_promotion_path(@promotion)}
      format.js   { render :layout => false }
    end
  end

  def destroy
    @promotion_action = @promotion.promotion_actions.find(params[:id])
    if @promotion_action.destroy
      flash[:success] = Colibri.t(:successfully_removed, :resource => Colibri.t(:promotion_action))
    end
    respond_to do |format|
      format.html { redirect_to colibri.edit_admin_promotion_path(@promotion)}
      format.js   { render :layout => false }
    end
  end

  private

  def load_promotion
    @promotion = Colibri::Promotion.find(params[:promotion_id])
  end

  def validate_promotion_action_type
    valid_promotion_action_types = Rails.application.config.colibri.promotions.actions.map(&:to_s)
    if !valid_promotion_action_types.include?(params[:action_type])
      flash[:error] = Colibri.t(:invalid_promotion_action)
      respond_to do |format|
        format.html { redirect_to colibri.edit_admin_promotion_path(@promotion)}
        format.js   { render :layout => false }
      end
    end
  end
end
