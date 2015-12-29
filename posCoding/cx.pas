unit cx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,StrUtils, DB, ADODB, MemDS, DBAccess, Uni,Math;
type
  PromotionResult=record        //定义结构
      PromotionID:string;      //促销ID
      PromotionName:string;    //促销名称
      TotalPrice:double;    // 优惠的金额（减少部分）
      PromDetail:TStringList;     // id(num,je)       促销详情
  end;
  SaleReceiptDetail=record
      commodity_id:string;   //商品编码
      Sale_num:double;      //销售数量
      SalePrice:double;    //销售价格
      CommType:string;     //商品类型ID
      SupplierID:string;   //供应商ID
  end;
type
  TForm1 = class(TForm)
    Button1: TButton;
    adoQuery1: TUniQuery;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function SearchRecord(SearchType:string;BeginPos:integer;SearchValue:string;SaleDetail: array of SaleReceiptDetail):integer;
  public
      procedure ComputePromotion(IsMember :boolean; var SaleDetail: array of SaleReceiptDetail;var PromResult:array of PromotionResult);
      { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses C_ZB_DataModule;

{$R *.dfm}
function TForm1.SearchRecord(SearchType:string;BeginPos:integer;SearchValue:string;SaleDetail: array of SaleReceiptDetail):integer;
   //  SearchType:sp,lx,gys
var
   i:integer;
begin
   if BeginPos>length(SaleDetail)-1 then
      begin SearchRecord:=-1; exit;end;
   if SearchType='sp' then
   for i:=0 to length(SaleDetail)-1 do
     if  SaleDetail[i].commodity_id = SearchValue then
        begin SearchRecord:=i; exit; end;
   if SearchType='lx' then
   for i:=BeginPos to length(SaleDetail)-1 do
     if  SaleDetail[i].CommType = SearchValue then
        begin SearchRecord:=i; exit; end;
   if SearchType='gys' then
   for i:=BeginPos to length(SaleDetail)-1 do
     if  SaleDetail[i].SupplierID = SearchValue then
        begin SearchRecord:=i; exit; end;
   SearchRecord:=-1;
end;
procedure TForm1.ComputePromotion(IsMember :boolean; var SaleDetail: array of SaleReceiptDetail;
            var PromResult:array of PromotionResult);
var
   vl_temp_PromotionResult: PromotionResult;
   flag:boolean;
   vl_temp_je,vl_f_discount,vl_f_temp:double;
   vl_proID,vl_sql,vl_promotion_type:string;
   query_temp,query_promotion,query_promotion_detail:TUniQuery;  // 记录临时，促销方案，促销详细
   IndexOfCurrentPromResult:integer;
   i,j,k:integer;
   vl_9_zdsplb,vl_9_zdpwsplb,vl_9_zdpwdp,vl_9_zdgys,vl_9_zdpwgys: TStringList;
   vl_9_zdxsje,vl_9_zdje:double;
   vl_9_zddp:string;
   vl_9_zdsl,vl_9_zdzk,vl_9_zddj:double;
begin
   query_promotion:=TUniQuery.Create(nil);
   query_promotion.Connection :=DM_ZB_Common.VG_ZB_ADOConnection;
   query_promotion_detail:=TUniQuery.Create(nil);
   query_promotion_detail.Connection :=DM_ZB_Common.VG_ZB_ADOConnection;
   query_temp:=TUniQuery.Create(nil);
   query_temp.Connection :=DM_ZB_Common.VG_ZB_ADOConnection;
   vl_9_zdsplb:=TStringList.create;
   vl_9_zdpwsplb:=TStringList.create;
   vl_9_zdpwdp:=TStringList.create;
   vl_9_zdgys:=TStringList.create;
   vl_9_zdpwgys:=TStringList.create;
   for i:=0 to length(PromResult)-1 do
         begin
              PromResult[i].PromotionID :='';PromResult[i].PromotionName :='';
              PromResult[i].TotalPrice :=0; PromResult[i].PromDetail:=TStringList.create;
         end;
   vl_sql:='select promotion_id,promotion_brief,is_allow_point,promotion_type '
            +' from ( '
	          +' select promotion_id,promotion_brief,is_mem_prom,is_allow_point,promotion_type,'
            +' 	case when b.wd_now=1 then substring(b.wd,1,1)'
					  +' when b.wd_now=2 then substring(b.wd,2,1) when b.wd_now=3 then substring(b.wd,3,1) '
					  +' when b.wd_now=4 then substring(b.wd,4,1) when b.wd_now=5 then substring(b.wd,5,1)'
					  +' when b.wd_now=6 then substring(b.wd,6,1) when b.wd_now=7 then substring(b.wd,7,1) '
					  +' else ''0'' end weekday,'
					  +' case when b.dd is null then 0 else b.dd end designeddate, dd_now,begin_date '
            +' from '
            +'(select case when designated_week is null then ''0000000'' when trim(designated_week)='''' then ''0000000'''
					  +' else designated_week end wd, extract(dow from now()) wd_now ,'
					  +' promotion_id,promotion_brief,is_mem_prom,is_allow_point,begin_date,'
					  +' case when designated_date is null then -1 else designated_date end dd,promotion_type,'
					  +' extract(day from now()) dd_now from t_bi_promotion '
			      +' where (status=''2'') and (promotion_id in (select promotion_id from t_bi_promstore where store_id='''+DM_ZB_Common.vg_str_departmentid+'''))'
						+' and (begin_date<CURRENT_DATE) and (end_date>CURRENT_DATE)';
   if IsMember=false then vl_sql:=vl_sql+' and (is_mem_prom is null or is_mem_prom=''0'' or is_mem_prom='''')';
	 vl_sql:=vl_sql+' and (begin_time<CURRENT_TIME) and (end_time>CURRENT_TIME) '
	          +') b) c where c.weekday=''1'' or designeddate=dd_now '
            +' order by begin_date desc' ;

   query_promotion.SQL.Clear;
   if dm_zb_common.vg_b_debug then
       query_promotion.SQL.Add('select promotion_id,promotion_brief,is_allow_point,promotion_type from t_bi_promotion')
   else  query_promotion.sql.Add(vl_sql); 
   query_promotion.Open;
   query_promotion.First;           // 获取有效促销方案
   IndexOfCurrentPromResult:=0;
   vl_temp_PromotionResult.PromDetail :=TStringList.Create;
   vl_temp_PromotionResult.PromDetail.Clear;
   while query_promotion.Eof=false do
      begin
        vl_temp_PromotionResult.PromotionID :=query_promotion.FieldValues['promotion_id'];
        vl_temp_PromotionResult.PromotionName:=query_promotion.FieldValues['promotion_brief'];
        vl_temp_PromotionResult.TotalPrice :=0;
        vl_temp_PromotionResult.PromDetail.Clear;   //需要清空链表数据
        if query_promotion.FieldByName('promotion_type').IsNull  then vl_promotion_type:=''
              else vl_promotion_type:=trim(query_promotion.FieldValues['promotion_type']);
        //促销类型  0：买几送几；1：促销特价；2：偶数促销；3：超额促销；4：捆绑促销；9：其他促销
        if vl_promotion_type='0' then
          begin    //买几送几 t_bi_mjsj:promotion_id,buy_comm_id,buy_comm_count,present_comm_id,present_comm_count,add_total
             vl_sql:='select buy_comm_id,buy_comm_count,present_comm_id,present_comm_count,add_total from t_bi_mjsj '
                      +' where promotion_id='''+trim(query_promotion.FieldValues['promotion_id'])+'''';
             query_promotion_detail.SQL.Clear ;
             query_promotion_detail.SQL.Add(vl_sql);
             query_promotion_detail.Open;
             query_promotion_detail.first;
             i:=0;
             while (query_promotion_detail.eof=false) do
                begin
                   i:=SearchRecord('sp',1,trim(query_promotion_detail.FieldValues['buy_comm_id']),SaleDetail);
                   if i>=0 then
                      begin
                         if  trim(query_promotion_detail.FieldValues['buy_comm_id'])=
                             trim(query_promotion_detail.FieldValues['present_comm_id']) then
                           j:=i
                          else
                           j:=SearchRecord('sp',1,trim(query_promotion_detail.FieldValues['present_comm_id']),SaleDetail);
                          if i=j then
                              k:=SaleDetail[i].Sale_num/(query_promotion_detail.FieldValues['buy_comm_count']+query_promotion_detail.FieldValues['present_comm_count'])
                           else
                              begin
                                 k:=SaleDetail[i].Sale_num/(query_promotion_detail.FieldValues['buy_comm_count']);
                                 if k>SaleDetail[j].Sale_num/(query_promotion_detail.FieldValues['present_comm_count']) then
                                    k:=SaleDetail[j].Sale_num/(query_promotion_detail.FieldValues['present_comm_count']);
                              end;
                           if k>0 then
                             begin
                                 vl_temp_je:= k * ( SaleDetail[j].SalePrice -query_promotion_detail.FieldValues['add_total']);
                                 vl_temp_PromotionResult.TotalPrice:=vl_temp_PromotionResult.TotalPrice + vl_temp_je;
                                 vl_temp_PromotionResult.PromDetail.add(SaleDetail[j].commodity_id+'('+floattostr(k*query_promotion_detail.FieldValues['present_comm_count'])+','
                                        +floattostr(vl_temp_je)+')');
                                 SaleDetail[i].Sale_num:=SaleDetail[i].Sale_num - k * query_promotion_detail.FieldValues['buy_comm_count'];
                                 SaleDetail[j].Sale_num:=SaleDetail[j].Sale_num - k * query_promotion_detail.FieldValues['present_comm_count'];
                             end;
                       end;
                    query_promotion_detail.next;
               end;
          end;
        //
        if vl_promotion_type='1' then
          begin    //促销特价    t_bi_promprice promotion_id,buy_comm_id,buy_comm_discount
             vl_sql:='select buy_comm_id,buy_comm_discount from t_bi_promprice '
                      +' where promotion_id='''+trim(query_promotion.FieldValues['promotion_id'])+'''';
             query_promotion_detail.SQL.Clear ;
             query_promotion_detail.SQL.Add(vl_sql);
             query_promotion_detail.Open;
             query_promotion_detail.first;
             i:=0;
             while (query_promotion_detail.eof=false) do
                begin
                   vl_f_discount:=0;
                   i:=SearchRecord('sp',1,trim(query_promotion_detail.FieldValues['buy_comm_id']),SaleDetail);
                   if i>=0 then
                      begin
                          if query_promotion_detail.fieldbyname('buy_comm_discount').isnull =false then
                              vl_f_discount:=query_promotion_detail.FieldValues['buy_comm_discount'];
                          if vl_f_discount<0.01 then vl_f_discount:=1;
                          vl_temp_je:= SaleDetail[i].SalePrice *SaleDetail[i].Sale_num *(1 -vl_f_discount);
                          vl_temp_PromotionResult.TotalPrice:=vl_temp_PromotionResult.TotalPrice + vl_temp_je;
                          vl_temp_PromotionResult.PromDetail.add(SaleDetail[i].commodity_id+'('+floattostr(SaleDetail[i].Sale_num)+','
                                        +floattostr(vl_temp_je)+')');
                          SaleDetail[i].Sale_num:=0;
                       end;
                    query_promotion_detail.next;
               end;
          end;
        if vl_promotion_type='2' then
          begin    //偶数促销  t_bi_evenprom:promotion_id,buy_comm_id,even_comm_discount
             vl_sql:='select buy_comm_id,even_comm_discount from t_bi_evenprom '
                      +' where promotion_id='''+trim(query_promotion.FieldValues['promotion_id'])+'''';
             query_promotion_detail.SQL.Clear ;
             query_promotion_detail.SQL.Add(vl_sql);
             query_promotion_detail.Open;
             query_promotion_detail.first;
             i:=0;
             while (query_promotion_detail.eof=false) do
                begin
                   vl_f_discount:=0;
                   i:=SearchRecord('sp',1,trim(query_promotion_detail.FieldValues['buy_comm_id']),SaleDetail);
                   if i>=0 then
                      begin
                          if query_promotion_detail.fieldbyname('even_comm_discount').isnull =false then
                              vl_f_discount:=query_promotion_detail.FieldValues['even_comm_discount'];
                          if vl_f_discount<0.01 then vl_f_discount:=1;
                          k:=floor(SaleDetail[i].Sale_num/2);
                          if k>=1 then
                              begin
                                vl_temp_je:= k *(1 -vl_f_discount)*SaleDetail[i].SalePrice;
                                vl_temp_PromotionResult.TotalPrice:=vl_temp_PromotionResult.TotalPrice + vl_temp_je;
                                vl_temp_PromotionResult.PromDetail.add(SaleDetail[i].commodity_id+'('+floattostr(SaleDetail[i].Sale_num/2)+','
                                        +floattostr(vl_temp_je)+')');
                                SaleDetail[i].Sale_num:=SaleDetail[i].Sale_num-k*2;
                              end;
                       end;
                    query_promotion_detail.next;
               end;
          end;
        if vl_promotion_type='3' then
          begin    //超额促销  t_bi_overpriceprom:promotion_id
                    // buy_comm_type,buy_comm_total,add_total,pres_comm_id,pres_comm_count
             vl_sql:='select commtype,buy_comm_total,add_total,pres_comm_id,pres_comm_count '
                      +' FROM (select promotion_id,'
                      +' case when buy_comm_type is null then '''' else buy_comm_type end commtype,'
                      +' buy_comm_total,add_total,pres_comm_id,pres_comm_count from t_bi_overpriceprom '
                      +' where promotion_id='''+trim(query_promotion.FieldValues['promotion_id'])+''''
                      +') a order by promotion_id,commtype desc  ';
             query_promotion_detail.SQL.Clear ;
             query_promotion_detail.SQL.Add(vl_sql);
             query_promotion_detail.Open;
             query_promotion_detail.first;
             i:=0;
             while (query_promotion_detail.eof=false) do
                begin
                   i:=SearchRecord('sp',i,trim(query_promotion_detail.FieldValues['pres_comm_id']),SaleDetail);
                   if i>=0 then
                      begin    //  找到赠送商品，统计总额
                          vl_temp_je:=0;
                          for j:=0 to length(SaleDetail) do
                              if trim(query_promotion_detail.FieldValues['commtype'])='' then
                                     vl_temp_je:=vl_temp_je+SaleDetail[j].Sale_num *SaleDetail[j].SalePrice
                              else if trim(query_promotion_detail.FieldValues['commtype'])=SaleDetail[j].CommType  then
                                     vl_temp_je:=vl_temp_je+SaleDetail[j].Sale_num *SaleDetail[j].SalePrice;
                          if query_promotion_detail.fieldbyname('buy_comm_total').isnull =false then
                              vl_f_temp:=query_promotion_detail.FieldValues['buy_comm_total']
                              else vl_f_temp:=0;
                           // 计算超额的重复次数，与赠送商品的次数，获取较小的
                          if vl_f_temp<0.01 then vl_f_temp:=1000000;
                          if trim(query_promotion_detail.FieldValues['commtype'])='' then
                             k:=vl_temp_je/(vl_f_temp+SaleDetail[i].SalePrice*query_promotion_detail.FieldValues['pres_comm_count'])
                          else
                             if trim(query_promotion_detail.FieldValues['commtype'])=SaleDetail[j].CommType then
                               k:=vl_temp_je/(vl_f_temp+SaleDetail[i].SalePrice*query_promotion_detail.FieldValues['pres_comm_count'])
                             else k:=floor(vl_temp_je/vl_f_temp);
                          if (k*query_promotion_detail.FieldValues['pres_comm_count'])>SaleDetail[i].Sale_num then
                             k:=floor(SaleDetail[i].Sale_num/query_promotion_detail.FieldValues['pres_comm_count']);
                          if k>=1 then
                              begin
                                for j:=0 to length(SaleDetail) do
                                   if trim(query_promotion_detail.FieldValues['commtype'])='' then
                                     SaleDetail[j].Sale_num:=0
                                 else if trim(query_promotion_detail.FieldValues['commtype'])=SaleDetail[j].CommType  then
                                     SaleDetail[j].Sale_num:=0;
                                if (trim(query_promotion_detail.FieldValues['commtype'])<>SaleDetail[i].CommType) and
                                    (trim(query_promotion_detail.FieldValues['commtype'])<>'') then
                                    SaleDetail[i].Sale_num:= SaleDetail[i].Sale_num -k*query_promotion_detail.FieldValues['pres_comm_count'];
                                vl_temp_je:= k*query_promotion_detail.FieldValues['pres_comm_count']*SaleDetail[i].SalePrice;
                                vl_temp_je:=vl_temp_je -k*query_promotion_detail.FieldValues['add_total'];
                                vl_temp_PromotionResult.TotalPrice:=vl_temp_PromotionResult.TotalPrice + vl_temp_je;
                                vl_temp_PromotionResult.PromDetail.add(SaleDetail[i].commodity_id+'('+floattostr(k*query_promotion_detail.FieldValues['add_total'])+','
                                        +floattostr(vl_temp_je)+')');
                              end;
                       end;   //  找到赠送商品，统计总额
                    query_promotion_detail.next;
                end;  // end of while
          end;
        if vl_promotion_type='4' then
          begin    //捆绑促销  t_bi_bindprom：promotion_id，prom_pack_total,prom_pack_id
                   // 捆绑促销详单：t_bi_bindpromdetail：commodity_id ，comm_count，promotion_id，prom_pack_id
             vl_sql:='select prom_pack_total,prom_pack_id from t_bi_bindprom '
                      +' where promotion_id='''+trim(query_promotion.FieldValues['promotion_id'])+'''';
             query_promotion_detail.SQL.Clear ;
             query_promotion_detail.SQL.Add(vl_sql);
             query_promotion_detail.Open;
             query_promotion_detail.first;
             i:=0;
             while (query_promotion_detail.eof=false) do
                begin
                   vl_sql:='select commodity_id,comm_count from t_bi_bindpromdetail where promotion_id='''
                      +trim(query_promotion.FieldValues['promotion_id'])+''' and prom_pack_id='+inttostr(query_promotion_detail.FieldValues['prom_pack_id']);
                   query_temp.SQL.Clear;
                   query_temp.SQL.Add(vl_sql);
                   query_temp.Open;
                   query_temp.First ;
                   j:=0;i:=0;k:=-1;
                   while (query_temp.Eof=false) and (i>=0) do
                      begin
                         i:=SearchRecord('sp',1,trim(query_temp.FieldValues['commodity_id']),SaleDetail);
                         vl_f_temp:=0;
                         if query_temp.Fieldbyname('comm_count').IsNull =false then
                             vl_f_temp:=query_temp.FieldValues['comm_count'];
                         if vl_f_temp<0.0001 then vl_f_temp:=0.0001;
                         if i>=0 then
                             if k<0 then k:=floor(SaleDetail[i].Sale_num/vl_f_temp)
                                else if k>floor(SaleDetail[i].Sale_num/vl_f_temp) then
                                    k:=floor(SaleDetail[i].Sale_num/vl_f_temp);
                         query_temp.Next ;
                      end;
                   vl_temp_je:=0;
                   if i>=0 then
                      begin
                          vl_sql:='';
                          query_temp.First ;
                          while query_temp.Eof=false  do
                            begin
                              i:=SearchRecord('sp',1,trim(query_temp.FieldValues['commodity_id']),SaleDetail);
                              vl_sql:=vl_sql+'('+trim(query_temp.FieldValues['commodity_id'])+',';
                              vl_temp_je:=vl_temp_je+SaleDetail[i].SalePrice*k*query_temp.FieldValues['comm_count'];
                              vl_sql:=vl_sql+floattostr(k*query_temp.FieldValues['comm_count'])+')';
                              SaleDetail[i].Sale_num :=SaleDetail[i].Sale_num -k*query_temp.FieldValues['comm_count'];
                              query_temp.Next ;
                            end;
                          vl_temp_je:=vl_temp_je - k*query_promotion_detail.FieldValues['prom_pack_total'];
                          vl_sql:=SaleDetail[i].commodity_id+'('+vl_sql+','+floattostr(vl_temp_je)+')';
                          vl_temp_PromotionResult.TotalPrice:=vl_temp_PromotionResult.TotalPrice + vl_temp_je;
                          vl_temp_PromotionResult.PromDetail.add(vl_sql);
                      end;
                    query_promotion_detail.next;
               end;
          end;
         ///////
        if vl_promotion_type='9' then
          begin    //其他促销
             vl_9_zdsplb.Clear;vl_9_zdpwsplb.Clear;vl_9_zdpwdp.Clear;vl_9_zdgys.Clear;vl_9_zdpwgys.Clear;
             vl_9_zdxsje:=0;vl_9_zdje:=0;
             vl_9_zddp:='';
             vl_9_zdsl:=0;vl_9_zdzk:=0;vl_9_zddj:=0;
             vl_sql:='select flag,num,factor,value from t_bi_promdetail where promotion_id='''+trim(query_promotion.FieldValues['promotion_id'])+''' order by flag';
             query_promotion_detail.sql.Clear;
             query_promotion_detail.SQL.Add(vl_sql);
             query_promotion_detail.Open ;
             query_promotion_detail.First ;
             while query_promotion_detail.eof=false do   //  获取规则
                begin
                   if query_promotion_detail.FieldValues['factor']='指定商品类别' then
                        vl_9_zdsplb.Add(trim(query_promotion_detail.FieldValues['value']))
                   else if query_promotion_detail.FieldValues['factor']='指定销售金额' then
                        vl_9_zdxsje:=strtofloat(query_promotion_detail.FieldValues['value'])
                   else if query_promotion_detail.FieldValues['factor']='整单金额' then
                        vl_9_zdje:=strtofloat(query_promotion_detail.FieldValues['value'])
                   else if query_promotion_detail.FieldValues['factor']='指定排外商品类别' then
                        vl_9_zdpwsplb.Add(trim(query_promotion_detail.FieldValues['value']))
                   else if query_promotion_detail.FieldValues['factor']='指定排外单品' then
                        vl_9_zdpwdp.Add(trim(query_promotion_detail.FieldValues['value']))
                   else if query_promotion_detail.FieldValues['factor']='指定供应商' then
                        vl_9_zdgys.Add(trim(query_promotion_detail.FieldValues['value']))
                   else if query_promotion_detail.FieldValues['factor']='指定排外供应商' then
                        vl_9_zdpwgys.Add(trim(query_promotion_detail.FieldValues['value']))
                   else if query_promotion_detail.FieldValues['factor']='指定单品' then
                        vl_9_zddp:=trim(query_promotion_detail.FieldValues['value'])
                   else if query_promotion_detail.FieldValues['factor']='指定数量' then
                        vl_9_zdsl:=strtofloat(query_promotion_detail.FieldValues['value'])
                   else if query_promotion_detail.FieldValues['factor']='指定折扣' then
                        vl_9_zdzk:=strtofloat(query_promotion_detail.FieldValues['value'])
                   else if query_promotion_detail.FieldValues['factor']='指定单价' then
                        vl_9_zddj:=strtofloat(query_promotion_detail.FieldValues['value'])
                   else showmessage('数据有误');
                   query_promotion_detail.Next ;
                end;
             if (vl_9_zdxsje>0) or (vl_9_zdje>0) then   // 按整额计算
                begin
                  k:=length(SaleDetail);
                  vl_temp_je:=0;
                  for i:=0 to k-1 do
                     begin
                        flag:=true;
                        if flag then    //  指定商品类别
                          begin
                            j:=0;
                            while j<vl_9_zdsplb.Count do
                               begin
                               vl_sql:=LeftStr(SaleDetail[i].CommType,length(trim(vl_9_zdsplb.ValueFromIndex[j])));
                               if trim(vl_9_zdsplb.ValueFromIndex[j])=vl_sql then
                                  j:=vl_9_zdsplb.Count+1
                                else j:=j+1;
                               end;
                            if (j=0) or (j>(vl_9_zdsplb.Count)) then flag:=true else flag:=false;
                           end;
                        if flag then    //  指定排外商品类别
                          begin
                            j:=0;
                            while j<vl_9_zdpwsplb.Count do
                               if trim(vl_9_zdpwsplb.ValueFromIndex[j])=leftstr(trim(SaleDetail[i].CommType),length(vl_9_zdpwsplb.ValueFromIndex[j])) then
                                  j:=vl_9_zdpwsplb.Count+1
                                else j:=j+1;
                            if  j>(vl_9_zdpwsplb.Count) then flag:=false else flag:=true;
                           end;
                        if flag then    //  指定排外商品
                          begin
                            j:=0;
                            while j<vl_9_zdpwdp.Count do
                               if trim(vl_9_zdpwdp.ValueFromIndex[j])=trim(SaleDetail[i].commodity_id) then
                                  j:=vl_9_zdpwdp.Count+1
                                else j:=j+1;
                            if  j>(vl_9_zdpwdp.Count) then flag:=false else flag:=true;
                           end;
                        if flag then    //  指定排外供应商
                          begin
                            j:=0;
                            while j<vl_9_zdpwgys.Count do
                               if trim(vl_9_zdpwgys.ValueFromIndex[j])=trim(SaleDetail[i].SupplierID ) then
                                  j:=vl_9_zdpwgys.Count+1
                                else j:=j+1;
                            if  j>(vl_9_zdpwgys.Count) then flag:=false else flag:=true;
                           end;
                        if flag then    //  指定供应商
                          begin
                            j:=0;
                            while j<vl_9_zdgys.Count do
                               if trim(vl_9_zdgys.ValueFromIndex[j])=trim(SaleDetail[i].SupplierID ) then
                                  j:=vl_9_zdgys.Count+1
                                else j:=j+1;
                            if  (j=0) or (j>(vl_9_zdgys.Count)) then flag:=true else flag:=false;
                           end;
                        // 前提满足
                        if flag then vl_temp_je:=vl_temp_je+ SaleDetail[i].Sale_num * SaleDetail[i].SalePrice ;
                     end; //  eod of for循环
                     k:=0;
                     j:=SearchRecord('sp',1,vl_9_zddp,SaleDetail);
                     if j>=0 then
                       if vl_9_zdxsje>0.1 then k:=floor(vl_temp_je/(vl_9_zdxsje+SaleDetail[j].SalePrice*vl_9_zdsl))
                         else if vl_9_zddj>0.1 then k:=floor(vl_temp_je/(vl_9_zdxsje+SaleDetail[j].SalePrice*vl_9_zdsl));
                     if flag and (j>=0) then
                           begin
                                 // 检查是否存在指定单品
                              if vl_9_zdzk>1 then vl_9_zdzk:=1;
                              if vl_9_zdzk<0.1 then vl_9_zdzk:=1;
                              if k*vl_9_zdsl>SaleDetail[j].Sale_num then k:=floor(SaleDetail[j].Sale_num) else k:=floor(k*vl_9_zdsl);  //获取优惠的数量
                              if vl_9_zddj>0.01 then
                                vl_temp_je:= k *(SaleDetail[j].SalePrice - vl_9_zddj)
                              else
                                vl_temp_je:=SaleDetail[i].SalePrice * k *(1 -vl_9_zdzk);
                              vl_temp_PromotionResult.TotalPrice:=vl_temp_PromotionResult.TotalPrice + vl_temp_je;
                              vl_temp_PromotionResult.PromDetail.add(SaleDetail[j].commodity_id+'('+floattostr(k)+','
                                        +floattostr(vl_temp_je)+')');
                              SaleDetail[j].Sale_num:=SaleDetail[j].Sale_num-k;
                           end;
                end
              else
                begin
                  k:=length(SaleDetail);
                  for i:=0 to k-1 do
                     begin
                        flag:=true;
                        if flag then    //  指定商品类别
                          begin
                            j:=0;
                            while j<vl_9_zdsplb.Count do
                               if trim(vl_9_zdsplb.ValueFromIndex[j])=leftstr(trim(SaleDetail[i].CommType),length(vl_9_zdsplb.ValueFromIndex[j])) then
                                  j:=vl_9_zdsplb.Count+1
                                else j:=j+1;
                            if (j=0) or (j>(vl_9_zdsplb.Count)) then flag:=true else flag:=false;
                           end;
                        if flag then    //  指定排外商品类别
                          begin
                            j:=0;
                            while j<vl_9_zdpwsplb.Count do
                               if trim(vl_9_zdpwsplb.ValueFromIndex[j])=leftstr(trim(SaleDetail[i].CommType),length(vl_9_zdpwsplb.ValueFromIndex[j])) then
                                  j:=vl_9_zdpwsplb.Count+1
                                else j:=j+1;
                            if  j>(vl_9_zdpwsplb.Count) then flag:=false else flag:=true;
                           end;
                        if flag then    //  指定排外商品
                          begin
                            j:=0;
                            while j<vl_9_zdpwdp.Count do
                               if trim(vl_9_zdpwdp.ValueFromIndex[j])=trim(SaleDetail[i].commodity_id) then
                                  j:=vl_9_zdpwdp.Count+1
                                else j:=j+1;
                            if  j>(vl_9_zdpwdp.Count) then flag:=false else flag:=true;
                           end;
                        if flag then    //  指定排外供应商
                          begin
                            j:=0;
                            while j<vl_9_zdpwgys.Count do
                               if trim(vl_9_zdpwgys.ValueFromIndex[j])=trim(SaleDetail[i].SupplierID ) then
                                  j:=vl_9_zdpwgys.Count+1
                                else j:=j+1;
                            if  j>(vl_9_zdpwgys.Count) then flag:=false else flag:=true;
                           end;
                        if flag then    //  指定供应商
                          begin
                            j:=0;
                            while j<vl_9_zdgys.Count do
                               if trim(vl_9_zdgys.ValueFromIndex[j])=trim(SaleDetail[i].SupplierID ) then
                                  j:=vl_9_zdgys.Count+1
                                else j:=j+1;
                            if  (j=0) or (j>(vl_9_zdgys.Count)) then flag:=true else flag:=false;
                           end;
                        // 前提满足
                        if flag then
                           begin
                                 // 检查是否存在指定单品
                              //j:=SearchRecord('sp',1,vl_9_zddp,SaleDetail);
                              if vl_9_zdzk>1 then vl_9_zdzk:=1;
                              if vl_9_zdzk<0.1 then vl_9_zdzk:=1;
                              vl_temp_je:= SaleDetail[i].Sale_num *(1 -vl_9_zdzk);
                              vl_temp_PromotionResult.TotalPrice:=vl_temp_PromotionResult.TotalPrice + vl_temp_je;
                              vl_temp_PromotionResult.PromDetail.add(SaleDetail[i].commodity_id+'('+floattostr(SaleDetail[i].Sale_num)+','
                                        +floattostr(vl_temp_je)+')');
                              SaleDetail[i].Sale_num:=0;
                           end;
                     end;
                end;
          end;
        // 将当前促销方案的数据加入结果中
        if vl_temp_PromotionResult.PromDetail.count>0 then
            begin
                PromResult[IndexOfCurrentPromResult]:= vl_temp_PromotionResult;
                IndexOfCurrentPromResult:=IndexOfCurrentPromResult+1;
            end;
        query_promotion.Next ;
      end;
    query_promotion.Destroy;
   //Length(CurrentRule);// 数组从0开始
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  SaleDetail: array of SaleReceiptDetail;      //定义一个动态数组
  PromResult:array [0..20] of PromotionResult;
  i:integer;
begin
   if dm_zb_common=nil then dm_zb_common:=TDM_ZB_Common.Create(nil);
   if dm_zb_common.SetupConnection =false then exit;
   setlength(SaleDetail,5);
   SaleDetail[0].commodity_id:='001';
   SaleDetail[0].Sale_num :=5;
   SaleDetail[0].SalePrice :=2;
   SaleDetail[0].CommType :='001';
   SaleDetail[0].SupplierID :='A';
   SaleDetail[1].commodity_id:='002';
   SaleDetail[1].Sale_num :=5;
   SaleDetail[1].SalePrice :=2;
   SaleDetail[1].CommType :='001';
   SaleDetail[1].SupplierID :='A';
   SaleDetail[2].commodity_id:='003';
   SaleDetail[2].Sale_num :=5;
   SaleDetail[2].SalePrice :=2;
   SaleDetail[2].CommType :='001';
   SaleDetail[2].SupplierID :='A';
   SaleDetail[3].commodity_id:='004';
   SaleDetail[3].Sale_num :=5;
   SaleDetail[3].SalePrice :=2;
   SaleDetail[3].CommType :='002';
   SaleDetail[3].SupplierID :='B';
   ComputePromotion(false,SaleDetail, PromResult);
   exit;
end;
{        vl_proID:=query_temp.FieldValues['promotionID'];
        for i:=0 to Length(CurrentRule)-1 do
            CurrentRule[i].PromotionID:='';
        CurrentRule[0].PromotionID :=query_temp.FieldValues['promotionID'];
        CurrentRule[0].flag :=query_temp.FieldValues['flag'];
        CurrentRule[0].no  :=query_temp.FieldValues['num'];
        CurrentRule[0].factor :=query_temp.FieldValues['factor'];
        CurrentRule[0].value  :=query_temp.FieldValues['value'];
        i:=1;
        while (query_temp.Eof=false) and (vl_proID=query_temp.FieldValues['promotionID']) do
           begin
              if i>Length(CurrentRule) then setlength(CurrentRule,i+1);
              CurrentRule[i].PromotionID :=query_temp.FieldValues['promotionID'];
              CurrentRule[i].flag :=query_temp.FieldValues['flag'];
              CurrentRule[i].no  :=query_temp.FieldValues['num'];
              CurrentRule[i].factor :=query_temp.FieldValues['factor'];
              CurrentRule[i].value  :=query_temp.FieldValues['value'];
              i:=i+1;
              query_temp.Next ;
           end;
        // 计算当前规则的促销情况
        flag:=false;
        for i:=0 to Length(CurrentRule)-1 do
            if (CurrentRule[i].factor='指定销售金额') or (CurrentRule[i].factor='整单金额') then flag:=true;
        if flag then
           begin
              //  包含整单销售金额与指定销售金额，销售商品逐个累加
           end
        else
           begin
              //  不包含整单销售金额与指定销售金额，分规则条件数逐个核算
              flag:=true;
              while flag do
                  begin
                      flag:=false;
                  end;
           end;
}
end.
