SUBROUTINE JBL.ENQ.LC.EXPORT.DETAILS(Y.RETURN)
*-----------------------------------------------------------------------------
* WRITTEN BY ENAMUL HAQUE
*            FDS BD
*            14 DECEMBER 2020
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON

    $USING ST.CompanyCreation
    $USING  LC.Contract

    $USING LC.Config
    $USING EB.Utility

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

    FN.LC ='F.LETTER.OF.CREDIT'
    F.LC =''

    FN.LC.TP.DES = 'F.LC.TYPES'
    F.LC.TP.DES =''

    FN.LC.HIS ='F.LETTER.OF.CREDIT$HIS'
    F.LC.HIS =''

    FN.DR ='F.DRAWINGS'
    F.DR =''

    FN.DR.HIS='F.DRAWINGS$HIS'
    F.DR.HIS =''
    
    Y.FROM.DATE =''
    Y.TO.DATE =''
    Y.CUS.NO =''
RETURN
*----------
OPENFILES:
*----------

    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.TP.DES,F.LC.TP.DES)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)
    EB.DataAccess.Opf(FN.DR,F.DR)
    EB.DataAccess.Opf(FN.DR.HIS,F.DR.HIS)
RETURN

*---------
PROCESS:
*---------
    LOCATE 'FROM.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.POS THEN
        Y.FROM.DATE = EB.Reports.getEnqSelection()<4,FROM.POS>
    END

    LOCATE 'TO.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING TO.POS THEN
        Y.TO.DATE = EB.Reports.getEnqSelection()<4,TO.POS>
    END
    
    LOCATE 'CUS.NO' IN EB.Reports.getEnqSelection()<2,1> SETTING CUS.POS THEN
        Y.CUS.NO= EB.Reports.getEnqSelection()<4,CUS.POS>
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
    ! DEBUG
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' AND Y.LC.DR.TYPE NE '' AND Y.LC.DR.CCY NE '' THEN
        ! LIVE
        L.STMT ='SELECT ':FN.DR :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.DOCREC GE ':Y.FROM.DATE:' AND LT.TF.DT.DOCREC LE ':Y.TO.DATE:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        
        !HISTORY
        H.STMT ='SELECT ':FN.DR.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.DOCREC GE ':Y.FROM.DATE:' AND LT.TF.DT.DOCREC LE ':Y.TO.DATE:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
        
    END ELSE
        IF Y.CUS.NO NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' AND Y.LC.DR.TYPE NE '' AND Y.LC.DR.CCY NE '' THEN
            ! LIVE
            L.STMT ='SELECT ':FN.DR :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.APL.CUSNO EQ ':Y.CUS.NO:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
            EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
            
            !HISTORY
            H.STMT ='SELECT ':FN.DR.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.APL.CUSNO EQ ':Y.CUS.NO:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
            EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
        END
        IF Y.CUS.NO NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' AND Y.LC.DR.TYPE NE '' AND Y.LC.DR.CCY NE '' THEN
            ! LIVE
            L.STMT ='SELECT ':FN.DR :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.DOCREC GE ':Y.FROM.DATE:' AND LT.TF.DT.DOCREC LE ':Y.TO.DATE:' AND LT.TF.APL.CUSNO EQ ':Y.CUS.NO:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
            EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
            
            !HISTORY
            H.STMT ='SELECT ':FN.DR.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.DOCREC GE ':Y.FROM.DATE:' AND LT.TF.DT.DOCREC LE ':Y.TO.DATE:' AND LT.TF.APL.CUSNO EQ ':Y.CUS.NO:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
            EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
        END
    END
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' AND Y.LC.DR.TYPE NE '' AND Y.LC.DR.CCY NE '' THEN
        ! LIVE
        L.STMT='SELECT ':FN.DR :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        
        !HISTORY
        H.STMT ='SELECT ':FN.DR.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.LC.DR.TYPE:' AND DRAW.CURRENCY EQ ':Y.LC.DR.CCY:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
    END
********************* KEEP LAST CURR IN HISTORY FILE  ********************************
    OCCUR=0
    SL=1
    FOR I=1 TO H.SIZE
        HIS.ID=H.REC<I>
        H.ID.PREFIX=HIS.ID[1,14]
        FOR J=1 TO H.SIZE
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
****************************** HISTORY LAST CURR END  ********************************
    H.NEW.SIZE=DCOUNT(NEW.H.REC,@FM)
    IF H.NEW.SIZE GT 0 THEN
        LOOP
            REMOVE Y.DR.LC.ID FROM NEW.H.REC SETTING POS
        WHILE Y.DR.LC.ID : POS
            EB.DataAccess.FRead(FN.DR.HIS,Y.DR.LC.ID,REC,F.DR.HIS,Y.ERR)
            GOSUB GET.LC.CATE.DES
            GOSUB  GET.RECORD.CALCULATION
        REPEAT
    END
************************* HIS  END *******************************************
************************* LIVE  START *****************************************
    IF L.SIZE GE 0 THEN
        LOOP
            REMOVE L.DR.LC.ID FROM L.REC SETTING POS
        WHILE L.DR.LC.ID : POS
            EB.DataAccess.FRead(FN.DR,L.DR.LC.ID,REC,F.DR,Y.Y.ERR)
            GOSUB GET.LC.CATE.DES
            GOSUB  GET.RECORD.CALCULATION
        REPEAT
    END
************** OPTIMIZE RETURN LIST START  **************************
    !E.LIST.SIZE -> EXISTING LIST SIZE
    E.LIST.SIZE=DCOUNT(Y.RETURN.DATA,@FM)
    E.SL=1
    FOR I=1 TO E.LIST.SIZE
        Y.DATA=Y.RETURN.DATA<I>
        IF Y.DATA NE '' THEN
            NEW.LIST<E.SL>=Y.DATA
            E.SL+=1
        END
    NEXT I
    Y.RETURN = NEW.LIST
RETURN
*----------------
GET.LC.CATE.DES:
*----------------
    EB.DataAccess.FRead(FN.LC.TP.DES,Y.LC.DR.TYPE,R.CATE,F.LC.TP.DES,Y.CATE.ERR)
*       Y.CATE.DES = R.CATE<LC.TYP.DESCRIPTION>
    Y.CATE.DES = R.CATE<LC.Config.Types.TypDescription>
RETURN
*----------------------
GET.RECORD.CALCULATION:
*----------------------
    !DRAWING LC TYPE
    Y.LC.DR.TYPE = REC<LC.Contract.Drawings.TfDrLcCreditType>
    !DRAWING LC AMOUNT
    Y.LC.DR.AMT = REC<LC.Contract.Drawings.TfDrDocumentAmount>
    !DRAWING LC CURRENCY
    Y.LC.DR.CURR = REC<LC.Contract.Drawings.TfDrDrawCurrency>
    
    !DR CUS ID
    ! DR.CUS.ID = REC<LC.Contract.Drawings.TfDrAssnCustNo>

    IF Y.CUS.NO NE '' THEN
        APPLICATION.NAMES = 'DRAWINGS'
        LOCAL.FIELDS = 'LT.TF.EXPR.NAME'
        EB.Foundation.MapLocalFields(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
        Y.CUS.NAME.POS=FLD.POS<1,1>
        Y.CUS.NAME = REC<LC.Contract.Drawings.TfDrLocalRef,Y.CUS.NAME.POS>
        !  Y.CUS.NO = DR.CUS.ID
    END ELSE
        Y.CUS.NO =''
        Y.CUS.NAME =''
    END
    Y.RETURN.DATA<-1>=Y.CATE.DES:"*":Y.LC.DR.TYPE:"*":Y.LC.DR.CURR:"*":Y.LC.DR.AMT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
RETURN
END
