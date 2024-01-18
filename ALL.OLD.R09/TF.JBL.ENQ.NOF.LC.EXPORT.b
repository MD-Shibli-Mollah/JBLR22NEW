SUBROUTINE TF.JBL.ENQ.NOF.LC.EXPORT(Y.RETURN)
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

    Y.TYPE ='CONT EFDU EFSC EFDT EFST EAUL EDCF ESCF ESCL EACL EDUF ESTC ESTF EMC EMU  EMTC EMTU'

    Y.FROM.DATE =''
    Y.TO.DATE =''
    Y.CUS.NO =''
    Y.CUS.NAME = ''
RETURN
*------------------
VAR.INITIALIZATION:
*------------------
    LC.DR.COUNT=0;            AMT.DR.TOT=0.00
    PREV.DR.LC.TYPE='';       PREV.DR.LC.CCY='';          PREV.DR.LC.AMT=0
    CURR.DR.LC.TYPE='';       CURR.DR.LC.CCY=''
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
    
    Y.COMPANY = EB.SystemTables.getIdCompany()
    
    
    Y.COMPANY = EB.SystemTables.getIdCompany()

    IF  Y.TO.DATE = "" THEN
        Y.TO.DATE = Y.FROM.DATE
    END
    !DEBUG
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
        ! LIVE
        L.STMT ='SELECT ':FN.DR :' WITH LC.CREDIT.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.DOCREC GE ':Y.FROM.DATE:' AND LT.TF.DT.DOCREC LE ':Y.TO.DATE:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        
        !HISTORY
        H.STMT ='SELECT ':FN.DR.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.DOCREC GE ':Y.FROM.DATE:' AND LT.TF.DT.DOCREC LE ':Y.TO.DATE:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
        
    END ELSE
        IF Y.CUS.NO NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
            ! LIVE
            L.STMT ='SELECT ':FN.DR :' WITH LC.CREDIT.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.APL.CUSNO EQ ':Y.CUS.NO:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
            EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
            
            !HISTORY
            H.STMT ='SELECT ':FN.DR.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.APL.CUSNO EQ ':Y.CUS.NO:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
            EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
        END
        IF Y.CUS.NO NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
            ! LIVE
            L.STMT ='SELECT ':FN.DR :' WITH LC.CREDIT.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.DOCREC GE ':Y.FROM.DATE:' AND LT.TF.DT.DOCREC LE ':Y.TO.DATE:' AND LT.TF.APL.CUSNO EQ ':Y.CUS.NO:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
            EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
            
            !HISTORY
            H.STMT ='SELECT ':FN.DR.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND LT.TF.DT.DOCREC GE ':Y.FROM.DATE:' AND LT.TF.DT.DOCREC LE ':Y.TO.DATE:' AND LT.TF.APL.CUSNO EQ ':Y.CUS.NO:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
            EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
        END
    END
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
        ! LIVE
        L.STMT='SELECT ':FN.DR :' WITH LC.CREDIT.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        
        !HISTORY
        H.STMT ='SELECT ':FN.DR.HIS :' WITH LC.CREDIT.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.CREDIT.TYPE BY DRAW.CURRENCY'
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
************************* HIS CALCULATION  START *******************************************
    GOSUB VAR.INITIALIZATION
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
    GOSUB GET.LAST.RECORD
************************* HIS CALCULATION  END *******************************************
************************* LIVE CALCULATION START *****************************************
    ! DEBUG
    GOSUB VAR.INITIALIZATION
    IF L.SIZE GE 0 THEN
        LOOP
            REMOVE L.DR.LC.ID FROM L.REC SETTING POS
        WHILE L.DR.LC.ID : POS
            EB.DataAccess.FRead(FN.DR,L.DR.LC.ID,REC,F.DR,Y.Y.ERR)
            GOSUB GET.LC.CATE.DES
            GOSUB  GET.RECORD.CALCULATION
        REPEAT
    END
    GOSUB GET.LAST.RECORD
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
******** SUMMATION OF HISTORY & LIVE RECORD LC.TYPE & CCY WISE  **********
*   NEW.LIST have all the record HISTORY & LIVE
*   when LC type & CCY match we will add in first record position & set 0 the opposite record position
    E.LIST.SIZE=DCOUNT(NEW.LIST,@FM)
    E.SL=1

    FOR I=1 TO E.LIST.SIZE
        REC.1 = NEW.LIST<I>
    
        REC.LC.TYPE.1=FIELD(REC.1,"*",2)
        REC.LC.CCY.1=FIELD(REC.1,"*",4)
        REC.LC.COUNT.1=FIELD(REC.1,"*",3)
        REC.LC.TOT.AMT.1=FIELD(REC.1,"*",5)
    
    
        FOR J=I+1 TO E.LIST.SIZE
            REC.2 = NEW.LIST<J>
            REC.LC.TYPE.2=FIELD(REC.2,"*",2)
            REC.LC.CCY.2=FIELD(REC.2,"*",4)
            REC.LC.COUNT.2=FIELD(REC.2,"*",3)
            REC.LC.TOT.AMT.2=FIELD(REC.2,"*",5)
            IF REC.LC.TYPE.1 EQ REC.LC.TYPE.2 AND REC.LC.CCY.1 EQ REC.LC.CCY.2 THEN
        
                LC.COUNT=REC.LC.COUNT.1 + REC.LC.COUNT.2
                AMT.TOT=REC.LC.TOT.AMT.1 + REC.LC.TOT.AMT.2
            
                REC.1= Y.CATE.DES:"*":REC.LC.TYPE.1:"*":LC.COUNT:"*":REC.LC.CCY.1:"*":AMT.TOT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
                NEW.LIST<I> = REC.1
                LC.COUNT=0
                AMT.TOT=0
                REC.2=Y.CATE.DES:"*":REC.LC.TYPE.2:"*":LC.COUNT:"*":REC.LC.CCY.2:"*":AMT.TOT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
                NEW.LIST<J>= REC.2
            END
        NEXT J
    NEXT I
********** -----------remove record when we find 0 from NEW.LIST   *************************
*  now we create FINAL.LIST from NEW.LIST
    FOR I=1 TO E.LIST.SIZE
        REC.3=NEW.LIST<I>
        REC.LC.COUNT.3=FIELD(REC.3,"*",3)
        REC.LC.TOT.AMT.3=FIELD(REC.3,"*",5)
                
        IF REC.LC.COUNT.3 NE 0 AND REC.LC.TOT.AMT.3 NE 0 THEN
            FINAL.LIST<-1>=NEW.LIST<I>
        END
    NEXT I
    FINAL.LIST.SIZE=DCOUNT(FINAL.LIST,@FM)
    Y.RETURN<-1>= FINAL.LIST
RETURN
************** OPTIMIZE RETURN LIST END  **************************
*----------------
GET.LC.CATE.DES:
*----------------
    EB.DataAccess.FRead(FN.LC.TP.DES,Y.LC.DR.TYPE,R.CATE,F.LC.TP.DES,Y.CATE.ERR)
*       Y.CATE.DES = R.CATE<LC.TYP.DESCRIPTION>
    Y.CATE.DES = R.CATE<LC.Config.Types.TypDescription>
RETURN
*----------------
GET.LAST.RECORD:
*-----------------
    IF LC.DR.COUNT  NE 0 AND PREV.DR.LC.TYPE NE '' THEN
        Y.RETURN.DATA<-1>=Y.CATE.DES:"*":PREV.DR.LC.TYPE:"*":LC.DR.COUNT:"*":PREV.DR.LC.CCY:"*":AMT.DR.TOT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
    END
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
    
    ! DR.CUS.ID = REC<LC.Contract.Drawings.TfDrAssnCustNo>
    
    IF Y.CUS.NO NE '' THEN
        IF Y.CUS.NAME EQ '' THEN
            APPLICATION.NAMES = 'DRAWINGS'
            LOCAL.FIELDS = 'LT.TF.EXPR.NAME'
            EB.Foundation.MapLocalFields(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
            Y.CUS.NAME.POS=FLD.POS<1,1>
            Y.CUS.NAME = REC<LC.Contract.Drawings.TfDrLocalRef,Y.CUS.NAME.POS>
        END
    END ELSE
        Y.CUS.NO =''
        Y.CUS.NAME =''
    END

    CURR.DR.LC.TYPE=Y.LC.DR.TYPE
    CURR.DR.LC.CCY=Y.LC.DR.CURR
    ! GOSUB GET.LC.CATE.DES

    IF PREV.DR.LC.TYPE EQ '' AND PREV.DR.LC.CCY EQ '' THEN
        PREV.DR.LC.TYPE= CURR.DR.LC.TYPE
        PREV.DR.LC.CCY=CURR.DR.LC.CCY
    END
      
    IF PREV.DR.LC.TYPE EQ CURR.DR.LC.TYPE THEN
        IF PREV.DR.LC.CCY EQ CURR.DR.LC.CCY THEN
            LC.DR.COUNT++;       AMT.DR.TOT +=Y.LC.DR.AMT
        END  ELSE
            Y.RETURN.DATA<-1>=Y.CATE.DES:"*":PREV.DR.LC.TYPE:"*":LC.DR.COUNT:"*":PREV.DR.LC.CCY:"*":AMT.DR.TOT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
            LC.DR.COUNT=1;     AMT.DR.TOT=Y.LC.DR.AMT;
            PREV.DR.LC.TYPE=CURR.DR.LC.TYPE;      PREV.DR.LC.CCY=CURR.DR.LC.CCY
        END
    END
    IF PREV.DR.LC.TYPE NE CURR.DR.LC.TYPE  THEN
        Y.RETURN.DATA<-1>=Y.CATE.DES:"*":PREV.DR.LC.TYPE:"*":LC.DR.COUNT:"*":PREV.DR.LC.CCY:"*":AMT.DR.TOT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
        PREV.DR.LC.TYPE = CURR.DR.LC.TYPE;     PREV.DR.LC.CCY=CURR.DR.LC.CCY
        LC.DR.COUNT=1;     AMT.DR.TOT=Y.LC.DR.AMT;
    END
RETURN
END
