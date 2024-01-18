SUBROUTINE TF.NOF.LC.SNAP.DETAILS(Y.RETURN)
*-----------------------------------------------------------------------------
* WRITTEN BY : ENAMUL HAQUE
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON
    
    $USING  ST.CompanyCreation
    $USING  LC.Contract
    $USING LC.Config
    $USING ST.Config
    $USING EB.Utility
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.API
    $USING EB.Display
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

    Y.CUS.NO =''
    Y.CATE=''
    
    Y.FROM.DATE=''
    Y.TO.DATE=''
    
    Y.CUS.ID =''
    Y.CUS.NAME =''
    
RETURN
*----------
OPENFILES:
*----------

    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.TP.DES,F.LC.TP.DES)
    EB.DataAccess.Opf(FN.CATE,F.CATE)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)
RETURN
*---------
PROCESS:
*---------
    
    LOCATE 'CUS.NO' IN EB.Reports.getEnqSelection()<2,1> SETTING CUS.POS THEN
        Y.CUS.NO = EB.Reports.getEnqSelection()<4,CUS.POS>
    END
    
    LOCATE 'FROM.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.POS THEN
        Y.FROM.DATE = EB.Reports.getEnqSelection()<4,FROM.POS>
    END
    
    LOCATE 'TO.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING TO.POS THEN
        Y.TO.DATE = EB.Reports.getEnqSelection()<4,TO.POS>
    END
    
    LOCATE 'LC.TYPE' IN EB.Reports.getEnqSelection()<2,1> SETTING TYPE.POS THEN
        Y.LC.TYPE = EB.Reports.getEnqSelection()<4,TYPE.POS>
    END
    
    
    LOCATE 'CCY' IN EB.Reports.getEnqSelection()<2,1> SETTING CCY.POS THEN
        Y.LC.CCY = EB.Reports.getEnqSelection()<4,CCY.POS>
    END
    
*    LOCATE 'CUS.NO' IN EB.Reports.getEnqSelection()<2,1> SETTING CUS.POS THEN
*        Y.CUS.NO = EB.Reports.getEnqSelection()<4,CUS.POS>
*    END
        
    Y.COMPANY=EB.SystemTables.getIdCompany()
    
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' AND Y.LC.TYPE NE '' AND Y.LC.CCY NE '' THEN
        ! LIVE
        L.SEL.CMD ='SELECT ':FN.LC:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND LC.CURRENCY EQ ':Y.LC.CCY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.SEL.CMD,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
   
        !HISTORY
        H.SEL.CMD ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND LC.CURRENCY EQ ':Y.LC.CCY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.SEL.CMD,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
        
    
    IF Y.CUS.NO NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' AND Y.LC.TYPE NE '' AND Y.LC.CCY NE '' THEN
        L.SEL.CMD ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND LC.CURRENCY EQ ':Y.LC.CCY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.SEL.CMD,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
    
        H.SEL.CMD ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND LC.CURRENCY EQ ':Y.LC.CCY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.SEL.CMD,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
        
    
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' AND Y.LC.TYPE NE '' AND Y.LC.CCY NE '' THEN
        L.SEL.CMD ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.SEL.CMD,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
    
        H.SEL.CMD ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.SEL.CMD,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    IF Y.CUS.NO NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' AND Y.LC.TYPE NE '' AND Y.LC.CCY NE '' THEN
        L.SEL.CMD ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.SEL.CMD,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
    
        H.SEL.CMD ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' AND LC.CURRENCY EQ ':Y.LC.CCY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.SEL.CMD,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    
    
    

********* HIS START   **********
    PREV.LC.TYPE=''
    PREV.LC.CCY=''
    PREV.LC.AMT=0
    SL=1

    ID.SIZE = DCOUNT(H.SEL.LIST,@FM)
    OCCURANCE=0
    SL=1
    FOR I=1 TO H.NO.OF.REC
        ID.1=H.SEL.LIST<I>
        ID.PREFIX=ID.1[1,12]
        FOR J=1 TO H.NO.OF.REC
            I.ID=H.SEL.LIST<J>
            I.ID.PREFIX=I.ID[1,12]
            IF ID.PREFIX EQ I.ID.PREFIX THEN
                OCCURANCE++
            END
        NEXT J
        ARR<SL>=ID.PREFIX:';':OCCURANCE
        SL++
        OCCURANCE -=1
        I+=OCCURANCE
        OCCURANCE=0
    NEXT I
    ARR.SIZE =DCOUNT(ARR,@FM)
    
    !!!!!!!!!!!   LIVE FILE START   !!!!!!!!!!!!!!!!!!
    IF L.NO.OF.REC GT 0 THEN
        LOOP
            REMOVE L.LC.ID FROM L.SEL.LIST SETTING L.POS
            !REMOVE SOMETHING FROM HIST SETTING POSITION
        WHILE L.LC.ID : L.POS
            EB.DataAccess.FRead(FN.LC,L.LC.ID,L.R.LC,F.LC,Y.ERR)
            Y.LC.NO = L.LC.ID
            Y.LC.TYPE = L.R.LC<LC.Contract.LetterOfCredit.TfLcLcType>
            Y.LC.CURR = L.R.LC <LC.Contract.LetterOfCredit.TfLcLcCurrency>
            Y.CATE = L.R.LC<LC.Contract.LetterOfCredit.TfLcCategoryCode>
            Y.CUS.NAME =L.R.LC<LC.Contract.LetterOfCredit.TfLcApplicant,1>
            Y.CUSTOMER.NO = L.R.LC<LC.Contract.LetterOfCredit.TfLcApplicantCustno>
            
            GOSUB GET.LC.CATE.DES
            IF Y.CUS.NO EQ Y.CUSTOMER.NO THEN
                Y.CUS.ID=Y.CUSTOMER.NO
                Y.CUS.NAME =Y.CUS.NAME
            END ELSE
                Y.CUS.ID =''
                Y.CUS.NAME=''
            END
            Y.RETURN<-1>= Y.LC.NO:"*":Y.CATE.DES:"*":Y.LC.TYPE:"*":Y.LC.CURR:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
        REPEAT
    END
    !!!!!!!!!!!   LIVE FILE END   !!!!!!!!!!!!!!!!!!
    
    IF ARR.SIZE GT 0 THEN
        LOOP
            REMOVE Y.LC.ID FROM ARR SETTING POS
        WHILE Y.LC.ID : POS
            EB.DataAccess.FRead(FN.LC.HIS,Y.LC.ID,R.LC,F.LC.HIS,Y.ERR)
            Y.LC.NO = Y.LC.ID
            !LC TYPE
            Y.LC.TYPE = R.LC<LC.Contract.LetterOfCredit.TfLcLcType>
            Y.LC.CURR = R.LC <LC.Contract.LetterOfCredit.TfLcLcCurrency>
            Y.CATE = R.LC<LC.Contract.LetterOfCredit.TfLcCategoryCode>
            Y.CUS.NAME =R.LC<LC.Contract.LetterOfCredit.TfLcApplicant,1>
            Y.CUSTOMER.NO =R.LC<LC.Contract.LetterOfCredit.TfLcApplicantCustno>
            IF Y.CUS.NO EQ Y.CUSTOMER.NO THEN
                Y.CUS.ID=Y.CUSTOMER.NO
                Y.CUS.NAME =Y.CUS.NAME
            END ELSE
                Y.CUS.ID =''
                Y.CUS.NAME=''
            END
            GOSUB GET.LC.CATE.DES
            !!!!!!!!!!          1            2               3            4             5             6              7              8
            Y.RETURN<-1>= Y.LC.NO:"*":Y.CATE.DES:"*":Y.LC.TYPE:"*":Y.LC.CURR:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
        REPEAT
    END
RETURN
*----------------
GET.LC.CATE.DES:
*----------------
    EB.DataAccess.FRead(FN.CATE,Y.CATE,R.CATE,F.CATE,Y.CATE.ERR)
    Y.CATE.DES = R.CATE<ST.Config.Category.EbCatDescription>
RETURN
END

