SUBROUTINE TF.JBL.ENQ.NOF.LC.BTB(Y.RETURN)
*-----------------------------------------------------------------------------
*   THIS ROUTINE WRITTEN BY : ENAMUL HAQUE
*                             13 DECEMBER 2020
*
**********************************************************************************
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON
    $USING  ST.CompanyCreation
    $USING  LC.Contract
    $USING LC.Config

    $USING ST.Config
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

    FN.CATE = 'F.CATEGORY'
    F.CATE =''

    FN.LC.HIS ='F.LETTER.OF.CREDIT$HIS'
    F.LC.HIS =''

    Y.TYPE ='BACL BDCF BFDC BFEU BFMC BFMU BIEC BMCF BMCL BSCF BSCL BSNE BSNF BSNI BSNL BSNT BSNZ BSPE BSPF BSPI BSPL BSPT BSPZ BSUF BUAE BUAF BUAI BUAL BUAT BUAZ BUNE BUNF BUNI BUNL BUNT BUNZ BZDC BZSC BZSE'
    Y.FROM.DATE='';       Y.TO.DATE='';         Y.CATE=''
    ! CUSTOMER INFO
    Y.CUS.ID ='';        Y.CUS.NAME ='';        Y.CUS.NO =''
RETURN
*----------
OPENFILES:
*----------
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.TP.DES,F.LC.TP.DES)
    EB.DataAccess.Opf(FN.CATE,F.CATE)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)
***************
RETURN
***************
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
        Y.CUS.NO = EB.Reports.getEnqSelection()<4,CUS.POS>
    END

    Y.COMPANY=EB.SystemTables.getIdCompany()
    
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
        ! LIVE
        L.STMT ='SELECT ':FN.LC:' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
   
        !HISTORY
        H.STMT ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
    END
    
    IF Y.CUS.NO NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
        L.STMT ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        !HISTORY
        H.STMT ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
    END
    
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
        L.STMT ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        !HISTORY
        H.STMT ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
    END
    
    IF Y.CUS.NO NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
        L.STMT ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        !HISTORY
        H.STMT ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
    END
    
    
    
    
    
********************* KEEP LAST CURR IN HISTORY FILE  ********************************
    OCCUR=0
    SL=1
    FOR I=1 TO H.SIZE
        HIS.ID=H.REC<I>
        H.ID.PREFIX=HIS.ID[1,12]
        FOR J=1 TO H.SIZE
            Y.ID=H.REC<J>
            Y.ID.PREFIX=Y.ID[1,12]
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
    LC.COUNT=0;            AMT.TOT=0.00
    PREV.LC.TYPE='';       PREV.LC.CCY='';          PREV.LC.AMT=0
    CURR.LC.TYPE='';       CURR.LC.CCY=''
  
    H.NEW.SIZE=DCOUNT(NEW.H.REC,@FM)
    IF H.NEW.SIZE GT 0 THEN
        LOOP
            REMOVE Y.LC.ID FROM NEW.H.REC SETTING POS
        WHILE Y.LC.ID : POS
            EB.DataAccess.FRead(FN.LC.HIS,Y.LC.ID,REC,F.LC.HIS,Y.ERR)
            Y.CUS.NAME = REC<LC.Contract.LetterOfCredit.TfLcApplicant,1>
            GOSUB GET.LC.CATE.DES
            IF Y.CUS.NO EQ '' THEN
                Y.CUS.NAME = ''
            END
            GOSUB  GET.RECORD.CALCULATION
        REPEAT
    END
    GOSUB GET.LAST.RECORD
************************* HIS CALCULATION  END *******************************************
************************* LIVE CALCULATION START *****************************************
    LC.COUNT=0;            AMT.TOT=0.00;            PREV.LC.TYPE='';     PREV.LC.CCY='';
    PREV.LC.AMT=0;         CURR.LC.TYPE='';         CURR.LC.CCY=''
    IF L.SIZE GE 0 THEN
        LOOP
            REMOVE L.LC.ID FROM L.REC SETTING POS
        WHILE L.LC.ID : POS
            EB.DataAccess.FRead(FN.LC,L.LC.ID,REC,F.LC,Y.Y.ERR)
            Y.CUS.NAME = REC<LC.Contract.LetterOfCredit.TfLcApplicant,1>
            GOSUB GET.LC.CATE.DES
            IF Y.CUS.NO EQ '' THEN
                Y.CUS.NAME = ''
            END
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
    FOR J=1 TO FINAL.LIST.SIZE
        Y.RETURN<-1>= FINAL.LIST<J>
    NEXT J
************** OPTIMIZE RETURN LIST END  **************************
RETURN
*----------------------
GET.RECORD.CALCULATION:
*----------------------
    !LC TYPE
    Y.LC.TYPE = REC<LC.Contract.LetterOfCredit.TfLcLcType>
    !LC AMOUNT
    Y.LC.AMT = REC<LC.Contract.LetterOfCredit.TfLcLcAmount>
    !LC CURRENCY
    Y.LC.CURR = REC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
    
    Y.CATE = REC<LC.Contract.LetterOfCredit.TfLcCategoryCode>
            
    CURR.LC.TYPE=Y.LC.TYPE
    CURR.LC.CCY=Y.LC.CURR
    ! GOSUB GET.LC.CATE.DES
            
    IF PREV.LC.TYPE EQ '' AND PREV.LC.CCY EQ '' THEN
        PREV.LC.TYPE= CURR.LC.TYPE
        PREV.LC.CCY=CURR.LC.CCY
    END
      
    IF PREV.LC.TYPE EQ CURR.LC.TYPE THEN
        IF PREV.LC.CCY EQ CURR.LC.CCY THEN
            LC.COUNT++;       AMT.TOT +=Y.LC.AMT
        END  ELSE
            Y.RETURN.DATA<-1>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":PREV.LC.CCY:"*":AMT.TOT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
            LC.COUNT=1;     AMT.TOT=Y.LC.AMT;
            PREV.LC.TYPE=CURR.LC.TYPE;      PREV.LC.CCY=CURR.LC.CCY
        END
    END
    IF PREV.LC.TYPE NE CURR.LC.TYPE  THEN
        Y.RETURN.DATA<-1>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":PREV.LC.CCY:"*":AMT.TOT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
        PREV.LC.TYPE = CURR.LC.TYPE;     PREV.LC.CCY=CURR.LC.CCY
        LC.COUNT=1;     AMT.TOT=Y.LC.AMT;
    END
RETURN
*----------------
GET.LC.CATE.DES:
*----------------
    EB.DataAccess.FRead(FN.CATE,Y.CATE,R.CATE,F.LC.TYPE,Y.TYPE.ERR)
    Y.CATE.DES = R.CATE<LC.Config.Types.TypDescription>
RETURN
*----------------
GET.LAST.RECORD:
*-----------------
    IF LC.COUNT  NE 0 AND PREV.LC.TYPE NE '' THEN
        Y.RETURN.DATA<-1>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":PREV.LC.CCY:"*":AMT.TOT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
    END
RETURN
*-----------------
END
