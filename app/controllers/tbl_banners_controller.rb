class TblBannersController < ApplicationController
  before_action :set_tbl_banner, only: [:show, :edit, :update, :destroy]

  # GET /tbl_banners
  # GET /tbl_banners.json
  def index
    @tbl_banners = TblBanner.all
   session[:bannerdeletionedit]=0
   # session[:deletebannerissue]=0
  end

  # GET /tbl_banners/1
  # GET /tbl_banners/1.json
  def show


  end

  # GET /tbl_banners/new
  def new
    @tbl_banner = TblBanner.new

    if params[:id] == nil
    session[:decision]=0
    else

      session[:pageid]=params[:id]
      session[:decision]=1
    end



  end

  # GET /tbl_banners/1/edit
  def edit
  end

  # POST /tbl_banners
  # POST /tbl_banners.json
  def create
    @tbl_banner = TblBanner.new(tbl_banner_params)

    respond_to do |format|
      if @tbl_banner.save
        format.html { redirect_to @tbl_banner, notice: 'Tbl banner was successfully created.' }

        @querylast=  TblBanner.last()

        @BannerID=@querylast.BannerID


        if params[:id] = @BannerID
          if session[:decision] == 1

            query = "INSERT INTO tbl_page_banners (PageID,BannerID) VALUES (#{session[:pageid]}, #{@BannerID});"

            ActiveRecord::Base.connection.execute(query);

          end

        end


        format.json { render :show, status: :created, location: @tbl_banner }
      else
        format.html { render :new }
        format.json { render json: @tbl_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tbl_banners/1
  # PATCH/PUT /tbl_banners/1.json
  def update
    respond_to do |format|
      if @tbl_banner.update(tbl_banner_params)
        format.html { redirect_to @tbl_banner, notice: 'Tbl banner was successfully updated.' }
        format.json { render :show, status: :ok, location: @tbl_banner }
      else
        format.html { render :edit }
        format.json { render json: @tbl_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tbl_banners/1
  # DELETE /tbl_banners/1.json
  def destroy

   if params[:id] != nil
        if  session[:bannerdeletionedit] == 1
       query = "DELETE FROM tbl_page_banners where PageID =#{session[:pageid]} and BannerID =#{params[:id]};"

        ActiveRecord::Base.connection.execute(query);
       end
   end

   if session[:bannerdeletionedit] == 0
     query = "DELETE FROM tbl_page_banners where PageID =#{session[:pageid]} and BannerID =#{params[:id]};"

     ActiveRecord::Base.connection.execute(query);

     @tbl_banner.destroy
   end


    respond_to do |format|
      format.html { redirect_to tbl_banners_url, notice: 'Tbl banner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tbl_banner
      @tbl_banner = TblBanner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tbl_banner_params
      params.require(:tbl_banner).permit(:BannerID, :Title, :Description, :ToolTip, :RedirectLink, :Type, :Status)
    end
end
