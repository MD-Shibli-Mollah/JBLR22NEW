SUBROUTINE TF.NOF.LC.CASH.BY.CATEG.CODE(Y.RETURN)
*-----------------------------------------------------------------------------
* WRITTEN BY : ENAMUL HAQUE
* FORTRESS DATA SERVICES
* DATE:
*-----------------------------------------------------------------------------
*************  PURPOSE OF THIS ROUTINE  ********************************
* FIND LC FROM LC.TYPES APPLICATION USING LC CATEGORY CODE(LT.LCTP.LC.CODE) AND THEIR OTHER PROPERTY
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
    $USING EB.Foundation
    $USING EB.LocalReferences
    
    
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*---------
INIT:
*---------
    FN.LC ='F.LETTER.OF.CREDIT'
    F.LC =''

    FN.LC.TYPE = 'F.LC.TYPES'
    F.LC.TYPE =''

    FN.CATE = 'F.CATEGORY'
    F.CATE =''

    FN.LC.HIS ='F.LETTER.OF.CREDIT$HIS'
    F.LC.HIS =''
    
    FN.DR='F.DRAWINGS'
    F.DR=''
    
    
    FN.DR.HIS='F.DRAWINGS$HIS'
    F.DR.HIS=''
    
    
    
RETURN
*----------
OPENFILES:
*----------

    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.TYPE,F.LC.TYPE)
    EB.DataAccess.Opf(FN.CATE,F.CATE)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)

    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.DR.HIS,F.DR.HIS)
RETURN
*---------
PROCESS:
*---------
   
    LOCATE 'LC.CODE' IN EB.Reports.getEnqSelection()<2,1> SETTING LC.CAT THEN
        Y.LC.CATEG = EB.Reports.getEnqSelection()<4,LC.CAT>
    END

    LOCATE 'FROM.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.POS THEN
        Y.FROM.DATE = EB.Reports.getEnqSelection()<4,FROM.POS>
    END
    
    LOCATE 'TO.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING TO.POS THEN
        Y.TO.DATE = EB.Reports.getEnqSelection()<4,TO.POS>
    END

    STMT = 'SELECT ':FN.LC.TYPE:' WITH LT.LCTP.LC.CODE EQ ':Y.LC.CATEG
    EB.DataAccess.Readlist(STMT,ID.LIST,'',NO.OF.REC,RET.CODE)
      
    Y.TEMP =''
    !Y.LC.TYPE = ID.LIST
    !CHANGE '^' TO ' ' IN Y.LC.TYPE
    T.DAT =''
    FOR J=1 TO NO.OF.REC
        IF J NE NO.OF.REC THEN
            Y.TEMP = ID.LIST<J>
            T.DAT = T.DAT:Y.TEMP:' '
        END
        ELSE
            Y.TEMP = ID.LIST<J>
            T.DAT = T.DAT:Y.TEMP
        END
        Y.TEMP =''
    NEXT J
    Y.LC.TYPE = T.DAT
        
    Y.COMPANY=EB.SystemTables.getIdCompany()
   
    IF Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
        LIVE.STMT = 'SELECT ':FN.LC:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(LIVE.STMT,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
        
        HIS.STMT = 'SELECT ':FN.LC.HIS:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(HIS.STMT,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    IF Y.FROM.DATE EQ '' AND Y.TO.DATE NE '' THEN
        LIVE.STMT = 'SELECT ':FN.LC:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(LIVE.STMT,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
        
        HIS.STMT = 'SELECT ':FN.LC.HIS:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE LE ':Y.TO.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(HIS.STMT,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    IF Y.FROM.DATE NE '' AND Y.TO.DATE EQ '' THEN
        LIVE.STMT = 'SELECT ':FN.LC:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(LIVE.STMT,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
        
        HIS.STMT = 'SELECT ':FN.LC.HIS:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' AND ISSUE.DATE GE ':Y.FROM.DATE:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(HIS.STMT,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
    
    IF Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
        LIVE.STMT = 'SELECT ':FN.LC:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(LIVE.STMT,L.SEL.LIST,'',L.NO.OF.REC,L.RET.CODE)
        
        HIS.STMT = 'SELECT ':FN.LC.HIS:' WITH LC.TYPE EQ ':Y.LC.TYPE:' AND CO.CODE EQ ':Y.COMPANY:' BY LC.TYPE BY LC.CURRENCY'
        EB.DataAccess.Readlist(HIS.STMT,H.SEL.LIST,'',H.NO.OF.REC,H.RET.CODE)
    END
   
    Y.LIVE.DATA = ''
    Y.HIS.DATA =''
    
    !!!!!!!!!!!!!!!!!!!!!!!!!!!! HIS DATE PROCESSING ->
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
        IF OCCURANCE NE 1 THEN
            ARR<SL>=ID.PREFIX:';':OCCURANCE
        END
        
        SL++
        OCCURANCE -=1
        I+=OCCURANCE
        OCCURANCE=0
    NEXT I
    ARR.SIZE =DCOUNT(ARR,@FM)
    !!!! REMOVE DUPLICATE FROM LIVE FILE  START
    !------------------------------------------
    Y.LIV.ID.TABLE =""
    Y.SERIAL=1
    FOR M=1 TO L.NO.OF.REC
        Y.LIVEE.ID = L.SEL.LIST<M>
        FOUND =0
        FOR N1 =1 TO ARR.SIZE
            Y.HIS.IDD = ARR<N1>
            Y.HIS.CUR = Y.HIS.IDD[14,LEN(Y.HIS.IDD)]
            IF Y.LIVEE.ID EQ Y.HIS.IDD[1,12] AND Y.HIS.CUR EQ 1 THEN
                Y.HIS.NEW.LIST<-1> = Y.HIS.IDD
                FOUND =1
                BREAK
            END
        NEXT N1
        IF FOUND EQ 0 THEN
            Y.LIV.ID.TABLE<Y.SERIAL> = Y.LIVEE.ID
            Y.SERIAL++
        END
    NEXT M
   
    Y.LIVE.SEL.SIZE = DCOUNT(Y.LIV.ID.TABLE,@FM)
    !```````````````````````````````````````````````````````````
    ! FOR K=1 TO L.NO.OF.REC
    FOR K=1 TO Y.LIVE.SEL.SIZE
        Y.LC.ID = Y.LIV.ID.TABLE<K>
        !Y.LC.ID = L.SEL.LIST<K>
        EB.DataAccess.FRead(FN.LC,Y.LC.ID,L.R.LC,F.LC,Y.ERR)
        Y.OLD.LC.NUMBER = L.R.LC<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
        Y.ISSUE.DATE =  L.R.LC<LC.Contract.LetterOfCredit.TfLcIssueDate>
        Y.LC.AMOUNT =  L.R.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
        Y.LC.CURRENCY =  L.R.LC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
        Y.SHIPING.DATE= L.R.LC<LC.Contract.LetterOfCredit.TfLcLatestShipment>
        !CUSTOMER ID  TfLcApplicantCustno
        Y.LC.CUS.ID = L.R.LC<LC.Contract.LetterOfCredit.TfLcApplicantCustno>
        !Beneficiary
        Y.LC.BEN.NAME = L.R.LC<LC.Contract.LetterOfCredit.TfLcBeneficiary>
        ! 09     Advising Bank No.    TfLcAdvisingBk
        Y.ADVISING.BNK = L.R.LC<LC.Contract.LetterOfCredit.TfLcAdvisingBkCustno>
        ! 10 Local Amount
        Y.LOCAL.AMOUNT = L.R.LC<LC.Contract.LetterOfCredit.TfLcLcAmountLocal>
        !!!!!!! LOCAL FIELD REFERENCES START !!!!!!!!!!!
        !   11   Exh Rate -> LT.TF.EXCH.RATE
        Y.TF.EXC.RATE = L.R.LC<LC.Contract.LetterOfCredit.TfLcLcOrigRate>
        
        !   12   LT.TF.LC.TENOR -> LT.TF.LC.TENOR
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT", "LT.TF.LC.TENOR", TENOR.POS)
        Y.LC.TENOR = L.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,TENOR.POS>
        !   13   LT.TF.HS.CODE -> LT.TF.HS.CODE
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT", "LT.TF.HS.CODE", HS.CODE.POS)
        Y.HS.CODE = L.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,HS.CODE.POS>
        !   14   LT.TF.COMMO.UN -> LT.TF.COMMO.UN
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT", "LT.TF.COMMO.UN", COMMO.UN.POS)
        Y.COMMO.UN = L.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,COMMO.UN.POS>
        !   15  LT.TF.COMMO.VOL ->  LT.TF.COMMO.VOL
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.COMMO.VOL",COMMO.VOL.POS)
        Y.COMMO.VOL = L.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,COMMO.VOL.POS>
        ! 26 LT.TF.COMMO.NM
        
        !IF Y.LC.ID EQ 'TF2121564170' THEN
        !     DEBUG
        ! END
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.COMMO.NM",COMMO.NM.POS)
        Y.COMMO.NAME = L.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,COMMO.NM.POS>
        ! 27 COUNTRY OF ORIGIN  LT.TF.CTRY.ORGN
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.CTRY.ORGN",CTRY.ORGN.POS)
        Y.CTRY.ORGN = L.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,CTRY.ORGN.POS>

        !  16   LC Expiry Date  -> EXPIRY.DATE
        Y.LC.EXPIRY.DATE = L.R.LC<LC.Contract.LetterOfCredit.TfLcExpiryDate>
        !  17   Margin Percentage  -> PROVIS.PERCENT
        Y.MARGIN.PERCENT = L.R.LC<LC.Contract.LetterOfCredit.TfLcProvisPercent>
        !  18  Margin Amount  ->  PROVIS.AMOUNT   TfLcProvisAmount  Pro Os Amt.1
        Y.MARGIN.AMT = L.R.LC<LC.Contract.LetterOfCredit.TfLcProOsAmt>

        !  19  Amendment No.  ->  AMENDMENT.NO
        Y.AMENDMENT.NO =  L.R.LC<LC.Contract.LetterOfCredit.TfLcAmendmentNo>
        !  20  No. of Bills  -> NEXT.DRAWING
        Y.NEXT.DRAWING = L.R.LC<LC.Contract.LetterOfCredit.TfLcNextDrawing>
        GOSUB GET.NEXT.DRAWING
        !!````````````````~~~~~~~ 0       0         0    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Y.PRO.AWAIT.AMT = L.R.LC<LC.Contract.LetterOfCredit.TfLcProAwaitAmt>
        !---------------------!!!!!!! LOCAL FIELD REFERENCES END !!!!!!!!!!!-----------------
        !  21    Amount of Bills  -> DRAWINGS
        Y.DRAWING = L.R.LC<LC.Contract.LetterOfCredit.TfLcDrawings>
        ! -------  0         0              0            0    ------------
        !   IF Y.LC.ID EQ 'TF2121564170' THEN
        !       DEBUG
        !   END
        IF Y.MARGIN.AMT GT 0 AND Y.NEXT.DRAWING GT 0 THEN
            GOSUB GET.MERGIN.AMT
        END
        ! LC Amt LCY      0        0      0       0      0       0
        Y.AMT.LCY = Y.LC.AMOUNT * Y.TF.EXC.RATE
        CONVERT SM TO VM IN Y.LC.BEN.NAME
        CONVERT VM TO FM IN Y.LC.BEN.NAME
        !!!!!!                   1                 2           3                 4                    5             6                 7                8                      9                10               11                 12             13             14           15               16                   17                18              19                     20             21             22           23              24            25              26               27
        Y.LIVE.DATA<-1> = Y.OLD.LC.NUMBER:'*':Y.LC.ID:'*':Y.LC.CUS.ID:'*':Y.LC.BEN.NAME<1>:'*':Y.ISSUE.DATE:'*':Y.LC.AMOUNT:'*':Y.LC.CURRENCY:'*':Y.SHIPING.DATE:'*':Y.ADVISING.BNK:'*':Y.LOCAL.AMOUNT:'*':Y.TF.EXC.RATE:'*':Y.LC.TENOR:'*':Y.HS.CODE:'*':Y.COMMO.UN:'*':Y.COMMO.VOL:'*':Y.LC.EXPIRY.DATE:'*':Y.MARGIN.PERCENT:'*':Y.MARGIN.AMT:'*':Y.AMENDMENT.NO:'*':Y.NEXT.DRAWING:'*':Y.DRAWING:'*':Y.AMT.LCY:'*':Y.COMPANY:'*':Y.FROM.DATE:'*':Y.TO.DATE:'*':Y.COMMO.NAME:'*':Y.CTRY.ORGN
    NEXT K
    FOR I=1 TO ARR.SIZE
        Y.LC.ID = ARR<I>
        EB.DataAccess.FRead(FN.LC.HIS,Y.LC.ID,H.R.LC,F.LC.HIS,Y.ERR)
        Y.OLD.LC.NUMBER = H.R.LC<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
    
        Y.ISSUE.DATE =  H.R.LC<LC.Contract.LetterOfCredit.TfLcIssueDate>
        Y.LC.AMOUNT =  H.R.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
        Y.LC.CURRENCY =  H.R.LC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
        Y.SHIPING.DATE= H.R.LC<LC.Contract.LetterOfCredit.TfLcLatestShipment>
        !CUSTOMER ID  TfLcApplicantCustno
        Y.LC.CUS.ID = H.R.LC<LC.Contract.LetterOfCredit.TfLcApplicantCustno>
        !Beneficiary
        Y.LC.BEN.NAME = H.R.LC<LC.Contract.LetterOfCredit.TfLcBeneficiary>
        ! 09     Advising Bank No.    TfLcAdvisingBk
        Y.ADVISING.BNK = H.R.LC<LC.Contract.LetterOfCredit.TfLcAdvisingBkCustno>
        ! 10 Local Amount
        Y.LOCAL.AMOUNT = H.R.LC<LC.Contract.LetterOfCredit.TfLcLcAmountLocal>
        !!!!!!! LOCAL FIELD REFERENCES START !!!!!!!!!!!
        !   11   Exh Rate -> LT.TF.EXCH.RATE    LETTER.OF.CREDIT$HIS
        Y.TF.EXC.RATE = H.R.LC<LC.Contract.LetterOfCredit.TfLcLcOrigRate>
        !   12   LT.TF.LC.TENOR -> LT.TF.LC.TENOR
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT$HIS", "LT.TF.LC.TENOR", Y.TENOR.POS)
        !Y.TENOR.POS = FLD.POS<1,1>
        Y.LC.TENOR = H.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.TENOR.POS>
        !   13   LT.TF.HS.CODE -> LT.TF.HS.CODE
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT$HIS", "LT.TF.HS.CODE", HS.CODE.POS)
        !Y.HS.CODE.POS = HS.CODE.POS<1,1>
        Y.HS.CODE = H.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,HS.CODE.POS>
        !   14   LT.TF.COMMO.UN -> LT.TF.COMMO.UN
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT$HIS", "LT.TF.COMMO.UN", COMMO.UN.POS)
        !Y.COMMO.UN.POS = COMMO.UN.POS<1,1>
        Y.COMMO.UN = H.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,COMMO.UN.POS>
        !   15  LT.TF.COMMO.VOL ->  LT.TF.COMMO.VOL
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT$HIS", "LT.TF.COMMO.VOL", COMMO.VOL.POS)
        !Y.COMMO.VOL.POS = COMMO.VOL.POS<1,1>
        Y.COMMO.VOL = H.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,COMMO.VOL.POS>
        ! 26 LT.TF.COMMO.NM
        !EB.Foundation.MapLocalFields("LETTER.OF.CREDIT$HIS", "LT.TF.COMMO.NM", COMMO.NM.POS)
        EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT$HIS','LT.TF.COMMO.NM',COMMO.NM.POS)
        !Y.COMMO.NM.POS = COMMO.NM.POS<1,1>
        Y.COMMO.NAME = H.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,COMMO.NM.POS>
        ! 27 COUNTRY OF ORIGIN  LT.TF.CTRY.ORGN
        EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT$HIS", "LT.TF.CTRY.ORGN", CTRY.ORGN.POS)
        !Y.CTRY.ORGN.POS = CTRY.ORGN.POS<1,1>
        Y.CTRY.ORGN = H.R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,CTRY.ORGN.POS>
        !---------------------!!!!!!! LOCAL FIELD REFERENCES END !!!!!!!!!!!-----------------
        !  16   LC Expiry Date  -> EXPIRY.DATE
        Y.LC.EXPIRY.DATE = H.R.LC<LC.Contract.LetterOfCredit.TfLcExpiryDate>
        !  17   Margin Percentage  -> PROVIS.PERCENT
        Y.MARGIN.PERCENT = H.R.LC<LC.Contract.LetterOfCredit.TfLcProvisPercent>
        !  18  Margin Amount  ->  PROVIS.AMOUNT
        Y.MARGIN.AMT = H.R.LC<LC.Contract.LetterOfCredit.TfLcProOsAmt>
        !  19  Amendment No.  ->  AMENDMENT.NO
        Y.AMENDMENT.NO = H.R.LC<LC.Contract.LetterOfCredit.TfLcAmendmentNo>
        !  20  No. of Bills  -> NEXT.DRAWING
        Y.NEXT.DRAWING = H.R.LC<LC.Contract.LetterOfCredit.TfLcNextDrawing>
        GOSUB GET.NEXT.DRAWING
        !!````````````````~~~~~~~ 0       0         0    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Y.PRO.AWAIT.AMT = H.R.LC<LC.Contract.LetterOfCredit.TfLcProAwaitAmt>
        
        IF Y.MARGIN.AMT GT 0 AND Y.NEXT.DRAWING GT 0 THEN
            GOSUB GET.MERGIN.AMT
        END
        !---------------------!!!!!!! LOCAL FIELD REFERENCES END !!!!!!!!!!!-----------------
        !  21    Amount of Bills  -> DRAWINGS
        Y.DRAWING = H.R.LC<LC.Contract.LetterOfCredit.TfLcDrawings>
        ! LC Amt LCY
        Y.AMT.LCY = Y.LC.AMOUNT * Y.TF.EXC.RATE
        CONVERT SM TO VM IN Y.LC.BEN.NAME
        CONVERT VM TO FM IN Y.LC.BEN.NAME
        !!!!!!                   1                 2                3                 4                    5              6                 7                8                    9                10                11                 12            13             14           15               16                    17                  18                19                  20             21              22          23              24             25             26                  27
        Y.LIVE.DATA<-1> = Y.OLD.LC.NUMBER:'*':Y.LC.ID[1,12]:'*':Y.LC.CUS.ID:'*':Y.LC.BEN.NAME<1>:'*':Y.ISSUE.DATE:'*':Y.LC.AMOUNT:'*':Y.LC.CURRENCY:'*':Y.SHIPING.DATE:'*':Y.ADVISING.BNK:'*':Y.LOCAL.AMOUNT:'*':Y.TF.EXC.RATE:'*':Y.LC.TENOR:'*':Y.HS.CODE:'*':Y.COMMO.UN:'*':Y.COMMO.VOL:'*':Y.LC.EXPIRY.DATE:'*':Y.MARGIN.PERCENT:'*':Y.MARGIN.AMT:'*':Y.AMENDMENT.NO:'*':Y.NEXT.DRAWING:'*':Y.DRAWING:'*':Y.AMT.LCY:'*':Y.COMPANY:'*':Y.FROM.DATE:'*':Y.TO.DATE:'*':Y.COMMO.NAME:'*':Y.CTRY.ORGN
        !                 Y.OLD.LC.NUMBER:'*':Y.LC.ID[1,12]:'*':Y.LC.CUS.ID:'*':Y.LC.BEN.NAME<1>:'*':Y.ISSUE.DATE:'*':Y.LC.AMOUNT:'*':Y.LC.CURRENCY:'*':Y.SHIPING.DATE:'*':Y.ADVISING.BNK:'*':Y.LOCAL.AMOUNT:'*':Y.TF.EXC.RATE:'*':Y.LC.TENOR:'*':Y.HS.CODE:'*':Y.COMMO.UN:'*':Y.COMMO.VOL:'*':Y.LC.EXPIRY.DATE:'*':Y.MARGIN.PERCENT:'*':Y.MARGIN.AMT:'*':Y.AMENDMENT.NO:'*':Y.NEXT.DRAWING:'*':Y.DRAWING:'*':Y.AMT.LCY:'*':Y.COMPANY:'*':Y.FROM.DATE:'*':Y.TO.DATE:'*':Y.COMMO.NAME
    NEXT I
    Y.DATA.SIZE =DCOUNT(Y.LIVE.DATA,@FM)
    Y.SORTED.DATA = ''
    FOR I=1 TO Y.DATA.SIZE
        Y.TF.DATA = Y.LIVE.DATA<I>
        IF Y.TF.DATA NE '' THEN
            Y.TF.IDD = FIELD(Y.TF.DATA,"*",2,1)
            Y.DATA.FOUND =0
            FOR J =1 TO Y.DATA.SIZE
                Y.TF.DATA.2 = Y.LIVE.DATA<J>
                Y.TF.IDD.2 = FIELD(Y.TF.DATA.2,"*",2,1)
                                                                                                                                                                                                                
                IF Y.TF.IDD EQ Y.TF.IDD.2 AND Y.DATA.FOUND EQ 0 THEN
                    Y.SORTED.DATA<-1> = Y.TF.DATA
                    Y.DATA.FOUND =1
                END
                ELSE IF Y.TF.IDD EQ Y.TF.IDD.2 AND Y.DATA.FOUND NE 0 THEN
                    Y.LIVE.DATA<J> = ''
                END
            NEXT J
        END
    NEXT I

    Y.FINAL.DATA=''
    Y.MAIN.SIZE =DCOUNT(Y.SORTED.DATA,@FM)
    FOR K=1 TO Y.MAIN.SIZE
        Y.DDATA= Y.SORTED.DATA<K>
        YY.LC.IDD = FIELD(Y.DDATA,"*",2,1)
        IF YY.LC.IDD NE '' THEN
            Y.FINAL.DATA<-1>= Y.DDATA
        END
    NEXT K

    Y.RETURN<-1> =Y.FINAL.DATA
    !Y.RETURN<-1>= Y.SORTED.DATA
    !Y.LIVE.DATA
RETURN
*----------------
GET.NEXT.DRAWING:
*----------------
    IF Y.NEXT.DRAWING GT 01 OR Y.NEXT.DRAWING GT 1 THEN
        Y.NEXT.DRAWING = Y.NEXT.DRAWING-1
    END
    ELSE
        Y.NEXT.DRAWING = ""
    END
RETURN
*--------------
GET.MERGIN.AMT:
*--------------
    Y.MARGIN.AMT = Y.MARGIN.AMT - Y.PRO.AWAIT.AMT
    DRAW.STMT= "SELECT ":FN.DR:" WITH LC.ID EQ ":Y.LC.ID[1,12]
    EB.DataAccess.Readlist(DRAW.STMT,SEL.DR.LIST,'',DR.OF.REC,DR.ERR)
    IF SEL.DR.LIST NE '' THEN
        LOOP
            REMOVE Y.DR.ID FROM SEL.DR.LIST SETTING Y.DR.POS
        WHILE Y.DR.ID:Y.DR.POS
            EB.DataAccess.FRead(FN.DR,Y.DR.ID,R.DR.REC,F.DR,DR.ERR)
            Y.DR.PRO.AMT.REL = R.DR.REC<LC.Contract.Drawings.TfDrProvAmtRel>
            IF Y.DR.PRO.AMT.REL GT 0 THEN
                Y.MARGIN.AMT = Y.MARGIN.AMT+Y.DR.PRO.AMT.REL
            END
        REPEAT
    END
    ELSE
        DRAW.STMT= "SELECT ":FN.DR.HIS:" WITH LC.ID EQ ":Y.LC.ID[1,12]
        EB.DataAccess.Readlist(DRAW.STMT,SEL.DR.LIST,'',DR.OF.REC,DR.ERR)
        IF SEL.DR.LIST NE '' THEN
            LOOP
                REMOVE Y.DR.ID FROM SEL.DR.LIST SETTING Y.DR.POS
            WHILE Y.DR.ID:Y.DR.POS
                EB.DataAccess.FRead(FN.DR.HIS,Y.DR.ID,R.DR.REC,F.DR.HIS,DR.ERR)
                Y.DR.PRO.AMT.REL = R.DR.REC<LC.Contract.Drawings.TfDrProvAmtRel>
                IF Y.DR.PRO.AMT.REL GT 0 THEN
                    Y.MARGIN.AMT = Y.MARGIN.AMT+Y.DR.PRO.AMT.REL
                END
            REPEAT
        END
    END
RETURN
*--------------
END
