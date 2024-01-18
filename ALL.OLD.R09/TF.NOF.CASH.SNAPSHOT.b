SUBROUTINE TF.NOF.CASH.SNAPSHOT(Y.RETURN)
*-----------------------------------------------------------------------------
*
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

    !Y.TYPE ='CSPF CSPT'
    Y.TYPE ='CSPF CSPT CSNE CSNZ CSPE CSPZ CUAE CUAZ CUNE CUNZ CSNA CSNT CUAF CUAT CUNF CUNT CSNL CSNI CSPL CSPI CUAL CUAI CUNL CUNI'
    Y.CURRENCY.TYPE ='AED AUD BDT CAD CHF EUR GBP JPY SGD USD'
      
     
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
          
    Y.COMPANY=EB.SystemTables.getIdCompany()
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
        ! LIVE
        L.SEL.CMD ='SELECT ':FN.LC:' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.SEL.CMD,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
   
        !HISTORY
        H.SEL.CMD ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.SEL.CMD,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    IF Y.CUS.NO NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
        L.SEL.CMD ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.SEL.CMD,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
    
        H.SEL.CMD ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.SEL.CMD,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    IF Y.CUS.NO EQ '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
        L.SEL.CMD ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.SEL.CMD,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
    
        H.SEL.CMD ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.SEL.CMD,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    
    IF Y.CUS.NO NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
        L.SEL.CMD ='SELECT ':FN.LC :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(L.SEL.CMD,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
    
        H.SEL.CMD ='SELECT ':FN.LC.HIS :' WITH LC.TYPE EQ ':Y.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND CON.CUS.LINK EQ ':Y.CUS.NO:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(H.SEL.CMD,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    
    
    
    
    LC.COUNT=0;    LC.AMT=0
    PREV.LC.TYPE='';      PREV.LC.CCY='';      PREV.LC.AMT=0
    CURR.LC.TYPE='';      CURR.LC.CCY='';      LC.AMT.TOT=0.00
    SL=1
************  HIS START **********************************
    ! DEBUG
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
    
    IF ARR.SIZE GT 0 THEN
        LOOP
            REMOVE Y.LC.ID FROM ARR SETTING POS
        WHILE Y.LC.ID : POS
            EB.DataAccess.FRead(FN.LC.HIS,Y.LC.ID,R.LC,F.LC.HIS,Y.ERR)
            Y.LC.NO = Y.LC.ID
            !LC TYPE
            Y.LC.TYPE = R.LC<LC.Contract.LetterOfCredit.TfLcLcType>
            !LC CCY
            Y.LC.CURR = R.LC <LC.Contract.LetterOfCredit.TfLcLcCurrency>
            !LC AMOUNT
            Y.LC.AMT = R.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
            !CATEGORY DESCRIPTION
            Y.CATE = R.LC<LC.Contract.LetterOfCredit.TfLcCategoryCode>
            
            GOSUB GET.LC.CATE.DES
            ! CURR -> CURRENT
            CURR.LC.TYPE=Y.LC.TYPE
            CURR.LC.CCY=Y.LC.CURR
            LC.AMT =Y.LC.AMT
            
            IF PREV.LC.TYPE EQ '' AND PREV.LC.CCY EQ '' THEN
                PREV.LC.TYPE = CURR.LC.TYPE
                PREV.LC.CCY = CURR.LC.CCY
            END
            
            IF PREV.LC.TYPE EQ CURR.LC.TYPE  THEN
                IF PREV.LC.CCY EQ CURR.LC.CCY THEN
                    LC.COUNT++
                    LC.AMT.TOT +=LC.AMT
                END ELSE
                    ARR.LIST<SL>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":LC.AMT.TOT:"*":PREV.LC.CCY:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
                    SL++
                    LC.COUNT =1
                    LC.AMT.TOT =LC.AMT
                    PREV.LC.TYPE = CURR.LC.TYPE
                    PREV.LC.CCY = CURR.LC.CCY
                END
            END
            IF PREV.LC.TYPE NE CURR.LC.TYPE  THEN
                ARR.LIST<SL>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":LC.AMT.TOT:"*":PREV.LC.CCY:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
                SL++
                PREV.LC.TYPE = CURR.LC.TYPE
                PREV.LC.CCY = CURR.LC.CCY
                LC.COUNT=1
                LC.AMT.TOT =LC.AMT

            END
        REPEAT
        IF LC.COUNT  NE 0 AND PREV.LC.TYPE NE '' THEN
            ARR.LIST<SL>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":LC.AMT.TOT:"*":PREV.LC.CCY:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
            SL++
        END
    END
    
********* HIS END   **********
    LC.COUNT=0;            LC.AMT =0.00
    PREV.LC.TYPE='';       PREV.LC.CCY='';            PREV.LC.AMT=0
    CURR.LC.TYPE='';       CURR.LC.CCY='';            LC.AMT.TOT=0.00
       
**********************  LIVE FILE START  ********************
    IF L.NO.OF.REC GT 0 THEN
        LOOP
            REMOVE L.LC.ID FROM L.SEL.LIST SETTING L.POS
            !REMOVE SOMETHING FROM HIST SETTING POSITION
        WHILE L.LC.ID : L.POS
            EB.DataAccess.FRead(FN.LC,L.LC.ID,L.R.LC,F.LC,Y.ERR)
            Y.LC.NO = L.LC.ID
            !LC TYPE
            Y.LC.TYPE = L.R.LC<LC.Contract.LetterOfCredit.TfLcLcType>
            !LC CCY
            Y.LC.CURR = L.R.LC <LC.Contract.LetterOfCredit.TfLcLcCurrency>
            !LC AMOUNT
            Y.LC.AMT = L.R.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
            !CATEGORY DESCRIPTION
            Y.CATE = L.R.LC<LC.Contract.LetterOfCredit.TfLcCategoryCode>
            
            !CUSTOMER NAME
            Y.CUS.NAME =L.R.LC<LC.Contract.LetterOfCredit.TfLcApplicant,1>
        
            !CUSTOMER ID => Y.CUS.NO
            Y.CUSTOMER.NO = L.R.LC<LC.Contract.LetterOfCredit.TfLcApplicantCustno>
            GOSUB GET.LC.CATE.DES
            
            IF Y.CUS.NO EQ Y.CUSTOMER.NO THEN
                Y.CUS.ID=Y.CUSTOMER.NO
                Y.CUS.NAME =Y.CUS.NAME
            END ELSE
                Y.CUS.ID =''
                Y.CUS.NAME=''
            END
            ! CURR -> CURRENT
            CURR.LC.TYPE =Y.LC.TYPE
            CURR.LC.CCY =Y.LC.CURR
            LC.AMT =Y.LC.AMT
            
            IF PREV.LC.TYPE EQ '' AND PREV.LC.CCY EQ '' THEN
                PREV.LC.TYPE = CURR.LC.TYPE
                PREV.LC.CCY = CURR.LC.CCY
            END
        
            IF PREV.LC.TYPE EQ CURR.LC.TYPE  THEN
                IF PREV.LC.CCY EQ CURR.LC.CCY THEN
                    LC.COUNT++
                    LC.AMT.TOT +=LC.AMT
                END ELSE
                    ARR.LIST<SL>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":LC.AMT.TOT:"*":PREV.LC.CCY:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
                    SL++
                   
                    LC.COUNT =1
                    LC.AMT.TOT =LC.AMT
                    PREV.LC.TYPE = CURR.LC.TYPE
                    PREV.LC.CCY = CURR.LC.CCY
                END
            END
            IF PREV.LC.TYPE NE CURR.LC.TYPE  THEN
                ARR.LIST<SL>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":LC.AMT.TOT:"*":PREV.LC.CCY:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
                SL++
              
                PREV.LC.TYPE = CURR.LC.TYPE
                PREV.LC.CCY = CURR.LC.CCY
                LC.COUNT=1
                LC.AMT.TOT =LC.AMT
            END
        REPEAT
        IF LC.COUNT  NE 0 AND PREV.LC.TYPE NE '' THEN
            ARR.LIST<SL>=Y.CATE.DES:"*":PREV.LC.TYPE:"*":LC.COUNT:"*":LC.AMT.TOT:"*":PREV.LC.CCY:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
            SL++
        END
    END
********   PRINT RETURN  START   **********************
    LIST.SIZE=DCOUNT(ARR.LIST,@FM)
    N.SL=1
    FOR B1=1 TO LIST.SIZE
        C1=ARR.LIST<B1>
        IF C1 NE '' THEN
            NEW.LIST<N.SL>=C1
            N.SL+=1
        END
    NEXT B1
    N.LIST.SIZE=DCOUNT(NEW.LIST,@FM)
            
    FOR II=1 TO N.LIST.SIZE
        P1 = NEW.LIST<II>
       
        LC.TYPE.1=FIELD(P1,"*",2,1)
        LC.CCY.1=FIELD(P1,"*",5,1)
      
        LC.COUNT.1=FIELD(P1,"*",3,1)
        LC.AMT.TOT.1=FIELD(P1,"*",4,1)
        
        FOR JJ=II+1 TO N.LIST.SIZE
            P2=NEW.LIST<JJ>
            LC.TYPE.2=FIELD(P2,"*",2,1)
            LC.CCY.2=FIELD(P2,"*",5,1)
            
            LC.COUNT.2=FIELD(P2,"*",3,1)
            LC.AMT.TOT.2=FIELD(P2,"*",4,1)
            
            IF LC.TYPE.1 EQ LC.TYPE.2 AND LC.CCY.1 EQ LC.CCY.2 THEN
                LC.COUNT=LC.COUNT.1+LC.COUNT.2
                LC.AMT.TOT=LC.AMT.TOT.1 + LC.AMT.TOT.2
                P1= Y.CATE.DES:"*":LC.TYPE.1:"*":LC.COUNT:"*":LC.AMT.TOT:"*":LC.CCY.1:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
                NEW.LIST<II> = P1
                LC.AMT.TOT=0
                LC.COUNT=0
                P2=Y.CATE.DES:"*":LC.TYPE.2:"*":LC.COUNT:"*":LC.AMT.TOT:"*":LC.CCY.2:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.FROM.DATE:"*":Y.TO.DATE
                NEW.LIST<JJ>= P2
            END
        NEXT JJ
    NEXT II
********** -----------------------------  *************************
    SERIAL=1
    FOR KK=1 TO N.LIST.SIZE
        P3=NEW.LIST<KK>
        LC.COUNT.11=FIELD(P3,"*",3,1)
        LC.AMT.TOT.11=FIELD(P3,"*",4,1)
                
        IF LC.COUNT.11 NE 0 AND LC.AMT.TOT.11 NE 0 THEN
            CON.LIST<SERIAL>=NEW.LIST<KK>
            SERIAL++
        END
    NEXT KK
    CON.LIST.SIZE=DCOUNT(CON.LIST,@FM)
    FOR LL=1 TO CON.LIST.SIZE
        Y.RETURN<-1>= CON.LIST<LL>
    NEXT LL
***********************  LIVE FILE END **********************
RETURN
*----------------
GET.LC.CATE.DES:
*----------------
    EB.DataAccess.FRead(FN.CATE,Y.CATE,R.CATE,F.CATE,Y.CATE.ERR)
    Y.CATE.DES = R.CATE<ST.Config.Category.EbCatDescription>
RETURN
END