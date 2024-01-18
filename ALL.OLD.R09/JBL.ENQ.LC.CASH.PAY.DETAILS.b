SUBROUTINE JBL.ENQ.LC.CASH.PAY.DETAILS(Y.RETURN)
*-----------------------------------------------------------------------------
* Modification History : DATE : 21 DECEMBER 2020
*   THIS ROUTINE WRITTEN BY :  ENAMUL HAQUE
*                              FDS
*-----------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON

    $USING  ST.CompanyCreation
    $USING LC.Config
    $USING EB.Utility
    $USING ST.Config
 
    $USING  LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.API
    $USING EB.Display
    $USING EB.Updates
    $USING EB.Foundation
    $USING EB.Reports

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*---------
INIT:
*---------
    !DEBUG
    FN.LC.TYPE = 'F.LC.TYPES'
    F.LC.TYPE =''

    FN.DRAW = 'F.DRAWINGS'
    F.DRAW =''

    FN.DRAW.HIS = 'FBNK.DRAWINGS$HIS'
    F.DRAW.HIS =''

    !Y.TYPE ='CSNE CSNZ CSPE CSPZ CUAE CUAZ CUNE CUNZ CSNA CSNT CSPF CSPT CUAF CUAT CUNF CUNT CSNL CSNI CSPL CSPI CUAL CUAI CUNL CUNI'
    Y.DR.PER.LC.TYPE =""
    Y.DR.CUR.LC.TYPE =""
    Y.PRE.LC.TYPE =""
    Y.CUR.LC.TYPE =""
    Y.PRE.CATE =""
    Y.CUR.CATE =""
    Y.FROM.DATE =''
    Y.TO.DATE =''
    Y.JUL.FR.DT=''
    Y.JUL.TO.DT=''
    Y.CUS.NO =''
RETURN
*----------
OPENFILES:
*----------
    !DEBUG
    EB.DataAccess.Opf(FN.LC.TYPE,F.LC.TYPE)
    EB.DataAccess.Opf(FN.DRAW,F.DRAW)
    EB.DataAccess.Opf(FN.DRAW.HIS,F.DRAW.HIS)
RETURN
*---------
PROCESS:
*---------
    LOCATE 'FROM.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.POS THEN
        Y.FROM.DATE =  EB.Reports.getEnqSelection()<4,FROM.POS>
    END

    LOCATE 'TO.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING TO.POS THEN
        Y.TO.DATE =  EB.Reports.getEnqSelection()<4,TO.POS>
    END
     
    LOCATE 'CUS.NO' IN EB.Reports.getEnqSelection()<2,1> SETTING CUS.POS THEN
        Y.CUS.NO = EB.Reports.getEnqSelection()<4,CUS.POS>
    END
    LOCATE 'LC.TYPE' IN EB.Reports.getEnqSelection()<2,1> SETTING TYPE.POS THEN
        Y.LC.DR.TYPE = EB.Reports.getEnqSelection()<4,TYPE.POS>
    END
        
    LOCATE 'CCY' IN EB.Reports.getEnqSelection()<2,1> SETTING CCY.POS THEN
        Y.LC.DR.CCY = EB.Reports.getEnqSelection()<4,CCY.POS>
    END

    Y.COMPANY = EB.SystemTables.getIdCompany()

    IF  Y.TO.DATE = "" THEN
        Y.TO.DATE = Y.FROM.DATE
    END
    !DEBUG
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' AND Y.LC.DR.TYPE NE '' AND Y.LC.DR.CCY NE '' THEN
        !LIVE
        L.STMT ='SELECT ':FN.DRAW :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":') BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.IDS,L.ERR)
        !HIS
        H.STMT ='SELECT ':FN.DRAW.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":') BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.IDS,H.ERR)
    END
    
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' AND Y.LC.DR.TYPE NE '' AND Y.LC.DR.CCY NE '' THEN
        !LIVE                                                                                                                                      (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":')
        L.STMT ='SELECT ':FN.DRAW :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:'AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.PAYMNT GE ':Y.FROM.DATE:' AND LT.TF.DT.PAYMNT LE ':Y.TO.DATE:' AND (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":') BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.IDS,L.ERR)
    
        !HIS
        H.STMT ='SELECT ':FN.DRAW.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.PAYMNT GE ':Y.FROM.DATE:' AND LT.TF.DT.PAYMNT LE ':Y.TO.DATE:' AND (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":') BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.IDS,H.ERR)
    END
    IF Y.CUS.NO NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' AND Y.LC.DR.TYPE NE '' AND Y.LC.DR.CCY NE '' THEN
        !LIVE
        L.STMT ='SELECT ':FN.DRAW :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND CUSTOMER.LINK EQ ':Y.CUS.NO:' AND (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":') BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.IDS,L.ERR)
             
        !HIS
        H.STMT ='SELECT ':FN.DRAW.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND CUSTOMER.LINK EQ ':Y.CUS.NO:' AND (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":') BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.IDS,H.ERR)
    END
    IF Y.CUS.NO NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' AND Y.LC.DR.TYPE NE '' AND Y.LC.DR.CCY NE '' THEN
        !LIVE
        L.STMT ='SELECT ':FN.DRAW :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.PAYMNT GE ':Y.FROM.DATE:' AND LT.TF.DT.PAYMNT LE ':Y.TO.DATE:' AND CUSTOMER.LINK EQ ':Y.CUS.NO:' AND (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":') BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.IDS,L.ERR)
                      
        !HIS
        H.STMT ='SELECT ':FN.DRAW.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.PAYMNT GE ':Y.FROM.DATE:' AND LT.TF.DT.PAYMNT LE ':Y.TO.DATE:' AND CUSTOMER.LINK EQ ':Y.CUS.NO:' AND (DRAWING.TYPE EQ ':"MA":' OR  DRAWING.TYPE EQ ':"SP":') BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.IDS,H.ERR)
    END
    
    
********************* KEEP LAST CURR IN HISTORY FILE  ********************************
    OCCUR=0
    SL=1
    FOR I=1 TO H.IDS
        HIS.ID=H.REC<I>
        H.ID.PREFIX=HIS.ID[1,14]
        FOR J=1 TO H.IDS
            Y.ID=H.REC<J>
            Y.ID.PREFIX=Y.ID[1,14]
            IF H.ID.PREFIX EQ Y.ID.PREFIX THEN
                OCCUR++
            END
        NEXT J
        NEW.H.REC<SL>=H.ID.PREFIX:';':OCCUR
        SL++
        OCCUR -=1
        I+=OCCUR
        OCCUR=0
    NEXT I
******************************  X X X  -> LAST CURR END  ****************************
************************* HIS CALCULATION  START *******************************************
    H.NEW.SIZE=DCOUNT(NEW.H.REC,@FM)
    IF H.NEW.SIZE GT 0 THEN
        LOOP
            REMOVE Y.LC.ID FROM NEW.H.REC SETTING POS
        WHILE Y.LC.ID : POS
            EB.DataAccess.FRead(FN.DRAW.HIS,Y.LC.ID,R.DRAW.HIS,F.DRAW.HIS,Y.DRAW.HIS.ERR)
    
            !LC DRAWING TYPE
            Y.DRAW.LC.TYPE = R.DRAW.HIS<LC.Contract.Drawings.TfDrLcCreditType>
            !LC DRAWING AMOUNT
            Y.DRAW.AMT = R.DRAW.HIS<LC.Contract.Drawings.TfDrDocumentAmount>
            !LC DRAWING CURRENCY
            Y.DRAW.CURR = R.DRAW.HIS<LC.Contract.Drawings.TfDrDrawCurrency>
            
            !  GOSUB GET.DR.CUS.DES
            APPLICATION.NAMES = 'DRAWINGS'
            LOCAL.FIELDS = 'LT.TF.IMPR.NAME'
            EB.Foundation.MapLocalFields(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
            Y.IMP.NAME.POS=FLD.POS<1,1>
            Y.IMP.NAME = R.DRAW.HIS<LC.Contract.Drawings.TfDrLocalRef,Y.IMP.NAME.POS>
            IF Y.CUS.NO EQ '' THEN
                Y.IMP.NAME = ''
            END
            GOSUB GET.LC.CATE.DES
            Y.RETURN.DATA<-1>=Y.CATE.DES:"*":Y.DRAW.LC.TYPE:"*":Y.DRAW.CURR:"*":Y.DRAW.AMT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.IMP.NAME
        REPEAT
    END
************************* HIS CALCULATION  END *******************************************
************************* LIVE CALCULATION START *****************************************
    IF L.IDS GE 0 THEN
        LOOP
            REMOVE L.DR.ID FROM L.REC SETTING POS
        WHILE L.DR.ID : POS
            EB.DataAccess.FRead(FN.DRAW,L.DR.ID,R.DRAW,F.DRAW,Y.DRAW.ERR)
                                
            !LC DRAWING TYPE
            Y.DRAW.LC.TYPE = R.DRAW<LC.Contract.Drawings.TfDrLcCreditType>
            !LC DRAWING AMOUNT
            Y.DRAW.AMT = R.DRAW<LC.Contract.Drawings.TfDrDocumentAmount>
            !LC DRAWING CURRENCY
            Y.DRAW.CURR = R.DRAW<LC.Contract.Drawings.TfDrDrawCurrency>

            GOSUB GET.DR.CUS.DES
            GOSUB GET.LC.CATE.DES
            Y.RETURN.DATA<-1>=Y.CATE.DES:"*":Y.DRAW.LC.TYPE:"*":Y.DRAW.CURR:"*":Y.DRAW.AMT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.IMP.NAME
        REPEAT
    END
************************* LIVE CALCULATION END *****************************************
************** OPTIMIZE RETURN LIST START  **************************
    !E.LIST.SIZE -> EXISTING LIST SIZE
    E.LIST.SIZE=DCOUNT(Y.RETURN.DATA,@FM)
    E.SL=1
***  REMOVE BLANK DATA FROM Y.RETURN.DATA IF HAVE ANY
    FOR I=1 TO E.LIST.SIZE
        Y.DATA=Y.RETURN.DATA<I>
        IF Y.DATA NE '' THEN
            NEW.LIST<E.SL>=Y.DATA
            E.SL+=1
        END
    NEXT I
    Y.RETURN<-1>= NEW.LIST
************** OPTIMIZE RETURN LIST END  **************************
RETURN
*----------------
GET.LC.CATE.DES:
*----------------
    EB.DataAccess.FRead(FN.LC.TYPE,Y.DRAW.LC.TYPE,R.CATE,F.LC.TYPE,Y.TYPE.ERR)
    Y.CATE.DES = R.CATE<LC.Config.Types.TypDescription>
RETURN
*----------------
GET.DR.CUS.DES:
*----------------
    APPLICATION.NAMES = 'DRAWINGS'
    LOCAL.FIELDS = 'LT.TF.IMPR.NAME'
    EB.Foundation.MapLocalFields(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.IMP.NAME.POS=FLD.POS<1,1>
    Y.IMP.NAME = R.DRAW<LC.Contract.Drawings.TfDrLocalRef,Y.IMP.NAME.POS>
    IF Y.CUS.NO EQ '' THEN
        Y.IMP.NAME = ''
    END
RETURN
END