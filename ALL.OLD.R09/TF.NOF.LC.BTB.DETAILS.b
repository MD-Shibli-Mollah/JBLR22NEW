SUBROUTINE TF.NOF.LC.BTB.DETAILS(Y.RETURN)
*-----------------------------------------------------------------------------
*   THIS ROUTINE WRITTEN BY : ENAMUL HAQUE FDS
*                             22 DECEMBER 2020
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

    !Y.TYPE ='BACL BDCF BFDC BFEU BFMC BFMU BIEC BMCF BMCL BSCF BSCL BSNE BSNF BSNI BSNL BSNT BSNZ BSPE BSPF BSPI BSPL BSPT BSPZ BSUF BUAE BUAF BUAI BUAL BUAT BUAZ BUNE BUNF BUNI BUNL BUNT BUNZ BZDC BZSC BZSE'
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
    
    LOCATE 'LC.TYPE' IN EB.Reports.getEnqSelection()<2,1> SETTING TYPE.POS THEN
        Y.LC.TYPE = EB.Reports.getEnqSelection()<4,TYPE.POS>
    END
        
    LOCATE 'CCY' IN EB.Reports.getEnqSelection()<2,1> SETTING CCY.POS THEN
        Y.LC.CCY = EB.Reports.getEnqSelection()<4,CCY.POS>
    END

    Y.COMPANY=EB.SystemTables.getIdCompany()
    
    !DEBUG
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' AND Y.LC.TYPE NE '' AND Y.LC.CCY NE '' THEN
        ! LIVE
        L.STMT ='SELECT ':FN.LC:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
   
        !HISTORY
        H.STMT ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
    END
    
    IF Y.CUS.NO NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' AND Y.LC.TYPE NE '' AND Y.LC.CCY NE '' THEN
        L.STMT ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        !HISTORY
        H.STMT ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
    END
    
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' AND Y.LC.TYPE NE '' AND Y.LC.CCY NE '' THEN
        L.STMT ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        !HISTORY
        H.STMT ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.STMT,H.REC,'',H.SIZE,H.ERR)
    END
        
    IF Y.CUS.NO NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' AND Y.LC.TYPE NE '' AND Y.LC.CCY NE '' THEN
        L.STMT ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.STMT,L.REC,'',L.SIZE,L.ERR)
        !HISTORY
        H.STMT ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
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
    H.NEW.SIZE=DCOUNT(NEW.H.REC,@FM)
    IF H.NEW.SIZE GT 0 THEN
        LOOP
            REMOVE Y.LC.ID FROM NEW.H.REC SETTING POS
        WHILE Y.LC.ID : POS
            EB.DataAccess.FRead(FN.LC.HIS,Y.LC.ID,REC,F.LC.HIS,Y.ERR)
            GOSUB GET.LC.CATE.DES
            GOSUB  GET.RECORD.CALCULATION
        REPEAT
    END
************************* HIS CALCULATION  END *******************************************
************************* LIVE CALCULATION START *****************************************
    IF L.SIZE GE 0 THEN
        LOOP
            REMOVE L.LC.ID FROM L.REC SETTING POS
        WHILE L.LC.ID : POS
            EB.DataAccess.FRead(FN.LC,L.LC.ID,REC,F.LC,Y.Y.ERR)
            GOSUB GET.LC.CATE.DES
            GOSUB  GET.RECORD.CALCULATION
        REPEAT
    END
************************* LIVE CALCULATION END *****************************************
    
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
    Y.RETURN<-1>=NEW.LIST
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
            
    !Y.CUS.NAME = R.LC.HIS<TF.LC.APPLICANT,1>
    Y.CUS.NAME = REC<LC.Contract.LetterOfCredit.TfLcApplicant,1>
    GOSUB GET.LC.CATE.DES
    IF Y.CUS.NO EQ '' THEN
        Y.CUS.NAME = ''
    END
    Y.RETURN.DATA<-1>=Y.CATE.DES:"*":Y.LC.TYPE::"*":Y.LC.CURR:"*":Y.LC.AMT:"*":Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.CUS.NO:"*":Y.CUS.NAME
RETURN
*----------------
GET.LC.CATE.DES:
*----------------
    EB.DataAccess.FRead(FN.CATE,Y.CATE,R.CATE,F.LC.TYPE,Y.TYPE.ERR)
    Y.CATE.DES = R.CATE<LC.Config.Types.TypDescription>
RETURN
END
