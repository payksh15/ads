class AdsController < ApplicationController
  load_and_authorize_resource

  def create

    @ad = current_user.ads.build(params[:ad])
    if @ad.save
      flash[:notice] = t(:added, scope: [:ads])
      params[:ad] = nil
    else
      flash[:error] = @ad.errors.full_messages.join('. ')
    end

    redirect_to(:back, :ad => params[:ad])

  end

  def destroy

    @ad.destroy
    flash[:notice] = t(:deleted, scope: [:ads])
    redirect_to(:back)

  end

  def index

    ad_type_id = params['ad_type_id'].blank? ? nil : params['ad_type_id']
    order = params['created_at'] || 'created_at DESC'
    @ads = Ad.search(params['key_word'],
      :sql => {:include => [:user, :ad_type, :photos] },
      :conditions => {:ad_type_id => ad_type_id, :state => :published},
      :order => order, :page => params[:page], :per_page => 6)
    @ad_types = AdType.all

  end

  def update

    @ad.attributes = params[:ad]
    @ad.save
    redirect_to current_user

  end

  def show

    @ad_types = AdType.all
    if can? :create, Comment
      @comment = current_user.comments.build(params[:comment])
      @comment.ad_id = params[:id]
    end
    session[:return_to] ||= request.referer

  end

  def change_state

    @ad.public_send(params[:state_event])
    @ad.save
    flash[:notice] = t(:status_changed, scope: [:ads])
    redirect_to(:back)

  end

end
