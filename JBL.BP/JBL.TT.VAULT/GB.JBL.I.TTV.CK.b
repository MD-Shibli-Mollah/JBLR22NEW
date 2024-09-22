
SUBROUTINE GB.JBL.I.TTV.CK

*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: VERSION - EB.JBL.TT.VAULT,INPUTT
* Attach As: INPUT ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from TTV.CK
* 22/09/2024 -                          NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
* Two Routines are called - NOFILE.DAYEND.CASH.MEMO.LOCAL & CM.CALHUND
* TTV.CHECK.BAL Routine Codes are updated here as a GOSUB
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    
    $INSERT I_F.EB.JBL.TT.VAULT
    
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    $USING ST.CompanyCreation
    $USING TT.Config
    $USING EB.ErrorProcessing

    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
    
    GOSUB TTV.CHECK.BAL

    IF Y.ID.NEW[1,4] NE Y.ID.COMPANY[6,4] OR NUM(Y.ID.NEW[6,8]) NE 1 OR LEN(Y.ID.NEW) NE 13 THEN
*        AF = 0
        EB.SystemTables.setAf(0)
*        ETEXT = 'Invalid ID Entered. Proper ID Formation is [4 Digit Branch Code].[Value Date]'
        EB.SystemTables.setEtext('Invalid ID Entered. Proper ID Formation is [4 Digit Branch Code].[Value Date]')
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    IF Y.ID.NEW[6,8] GT Y.TODAY THEN
* AF = 0
        EB.SystemTables.setAf(0)
* ETEXT = 'Invalid ID Entered. Value Date can not be greater than Today.'
        EB.SystemTables.setEtext('Invalid ID Entered. Value Date can not be greater than Today.')
* CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    IF Y.ID.COMPANY[1,5] NE 'BD001' AND Y.ID.COMPANY EQ 'BD0015051' AND Y.ID.COMPANY EQ 'BD0019999' THEN
*        AF = 0
        EB.SystemTables.setAf(0)
*        ETEXT = 'This branch is not authorised for this operation.'
        EB.SystemTables.setEtext('This branch is not authorised for this operation.')
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
    FN.V = 'F.EB.JBL.TT.VAULT'
    F.V = ''
    
    EB.DataAccess.Opf(FN.V, F.V)
    
    F.UNIT = 0
    F.AMT = 0
    M.UNIT = 0
    M.AMT = 0
    N.UNIT = 0
    N.AMT = 0
    COIN = 0
    C.AMT = 0
    T.CUR.UNIT = 0
    T.CUT.AMT = 0
    
    Y.TTV.DENOM = EB.SystemTables.getRNew(EB.TT.83.DENOM)
    Y.TTV.COIN = EB.SystemTables.getRNew(EB.TT.83.COIN)
    Y.TTV.M.UNIT = EB.SystemTables.getRNew(EB.TT.83.M.UNIT)
    Y.TTV.F.UNIT = EB.SystemTables.getRNew(EB.TT.83.F.UNIT)
    Y.TTV.N.UNIT = EB.SystemTables.getRNew(EB.TT.83.N.UNIT)
    
    FOR II = 1 TO DCOUNT(Y.TTV.DENOM, @VM)
        IF Y.TTV.DENOM<1,II> EQ '' THEN
*            AF = 0
            EB.SystemTables.setAf(0)
*            ETEXT = 'Currency Can not be added.'
            EB.SystemTables.setEtext('Currency Can not be added.')
*            CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    
        Y.CUR = Y.TTV.DENOM<1,II>[4,LEN(Y.TTV.DENOM<1,II>)-3]
        IF (Y.CUR GT 5 AND Y.TTV.COIN<1,II> GT 0) OR COUNT(Y.TTV.COIN<1,II>,'.') GT 0 THEN
*            AF = TTV.COIN
            EB.SystemTables.setAf(EB.TT.83.COIN)
*            AV = I
            EB.SystemTables.setAv(II)
*            ETEXT = 'Invalid Coin Information.'
            EB.SystemTables.setEtext('Invalid Coin Information.')
*            CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
        IF COUNT(Y.TTV.M.UNIT<1,II>,'.') GT 0 THEN
*            AF = TTV.M.UNIT
            EB.SystemTables.setAf(EB.TT.83.M.UNIT)
*            AV = I
            EB.SystemTables.setAv(II)
*            ETEXT = 'Invalid Mutilated Note Information.'
            EB.SystemTables.setEtext('Invalid Mutilated Note Information.')
*            CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
        IF COUNT(Y.TTV.F.UNIT<1,II>,'.') GT 0 THEN
*            AF = TTV.F.UNIT
            EB.SystemTables.setAf(EB.TT.83.F.UNIT)
*            AV = I
            EB.SystemTables.setAv(II)
*            ETEXT = 'Invalid Fresh Note Information.'
            EB.SystemTables.setEtext('Invalid Fresh Note Information.')
*            CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
        IF COUNT(Y.TTV.N.UNIT<1,II>,'.') GT 0 THEN
*            AF = TTV.N.UNIT
            EB.SystemTables.setAf(EB.TT.83.N.UNIT)
*            AV = I
            EB.SystemTables.setAv(II)
*            ETEXT = 'Invalid Non-Issue Note Information.'
            EB.SystemTables.setEtext('Invalid Non-Issue Note Information.')
*            CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

        IF Y.CUR LT 1 THEN
            IF Y.TTV.M.UNIT<1,II> GT 0 THEN
*  AF = TTV.M.UNIT
                EB.SystemTables.setAf(EB.TT.83.M.UNIT)
*            AV = I
                EB.SystemTables.setAv(II)
* AV = I
* ETEXT = 'Coin should not be Mutilated Note.'
                EB.SystemTables.setEtext('Coin should not be Mutilated Note.')
* CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            IF Y.TTV.F.UNIT<1,II> GT 0 THEN
* AF = TTV.F.UNIT
                EB.SystemTables.setAf(EB.TT.83.F.UNIT)
* AV = I
                EB.SystemTables.setAv(II)
* ETEXT = 'Coin should not be Fresh Note.'
                EB.SystemTables.setEtext('Coin should not be Fresh Note.')
* CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            IF Y.TTV.N.UNIT<1,II> GT 0 THEN
* AF = TTV.N.UNIT
                EB.SystemTables.setAf(EB.TT.83.N.UNIT)
* AV = I
                EB.SystemTables.setAv(II)
* ETEXT = 'Coin should not be Non Issue Note.'
                EB.SystemTables.setEtext('Coin should not be Non Issue Note.')
* CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    
*--- This block is not required as it's already considered in GB.JBL.CR.TTV.CKID Routine--------------------------- *
*        IF R.NEW(TTV.F.UNIT)<1,II> EQ '' THEN R.NEW(TTV.F.UNIT)<1,II> = 0
*        IF R.NEW(TTV.M.UNIT)<1,II> EQ '' THEN R.NEW(TTV.M.UNIT)<1,II> = 0
*        IF R.NEW(TTV.N.UNIT)<1,II> EQ '' THEN R.NEW(TTV.N.UNIT)<1,II> = 0
*        IF R.NEW(TTV.COIN)<1,II> EQ '' THEN R.NEW(TTV.COIN)<1,II> = 0
*--- This block is not required END ----------------------- *

        F.UNIT = F.UNIT + Y.TTV.F.UNIT<1,II>
        F.AMT = F.AMT + Y.TTV.F.UNIT<1,II> * Y.CUR
        M.UNIT = M.UNIT + Y.TTV.M.UNIT<1,II>
        M.AMT = M.AMT + Y.TTV.M.UNIT<1,II> * Y.CUR
        N.UNIT = N.UNIT + Y.TTV.N.UNIT<1,II>
        N.AMT = N.AMT + Y.TTV.N.UNIT<1,II> * Y.CUR
        COIN = COIN + Y.TTV.COIN<1,II>
        C.AMT = C.AMT + Y.TTV.COIN<1,II> * Y.CUR
    NEXT II
    
    T.CUR.UNIT = T.CUR.UNIT + F.UNIT + M.UNIT + N.UNIT + COIN
    T.CUR.AMT = T.CUR.AMT + F.AMT + M.AMT + N.AMT + C.AMT
    IF COUNT(C.AMT,'.') EQ 1 AND LEN(FIELD(C.AMT,'.',2)) EQ 1 THEN C.AMT = C.AMT : '0'
    IF COUNT(T.CUR.AMT,'.') EQ 1 AND LEN(FIELD(T.CUR.AMT,'.',2)) EQ 1 THEN T.CUR.AMT = T.CUR.AMT : '0'
    LNGVAR = T.CUR.AMT
    TXTOUT = ''
    TXTVAR1=''
    INTVAL=''
    Y.COMI.LEN = LEN(T.CUR.AMT)
    IF Y.COMI.LEN LT 20 THEN
        INTVAL = FIELD(LNGVAR,'.',1)
        INTVAL3 = FIELD(LNGVAR,'.',2)

        IF INTVAL3 NE 0 THEN
            INTVAL2 = INTVAL3
        END ELSE
            INTVAL2 = 0
        END

        CORE = INT(INTVAL / 10000000)
        CALL CM.CALHUND(CORE,INTCORE)
        INTVAL = INT(INTVAL - INT(INTVAL / 10000000) * 10000000)

        LAC = INT(INTVAL / 100000)
        CALL CM.CALHUND(LAC,INTLAC)
        INTVAL = INT(INTVAL - INT(INTVAL / 100000) * 100000)

        THOUSAND = INT(INTVAL / 1000)
        CALL CM.CALHUND(THOUSAND,INTTHOUSAND)
        INTVAL = INT(INTVAL - INT(INTVAL / 1000) * 1000)

        HUNDRED = INT(INTVAL / 100)
        CALL CM.CALHUND(HUNDRED,INTHUNDRED)
        INTVAL = INT(INTVAL - INT(INTVAL / 100) * 100)

        REST = INT(INTVAL / 1)
        CALL CM.CALHUND(REST,INTREST)

        !DES=INT(INTVAL2 / 1)
        DES = FIELD(DROUND(LNGVAR),'.',2)
        IF LEN(DES) EQ '1' THEN DES = DES * 10
        CALL CM.CALHUND(DES,INTDES)

        IF LEN(INTCORE) EQ 0 THEN
            TXTVAR1=INTCORE:"":""
        END ELSE
            TXTVAR1=INTCORE:" ":"Crore"
        END

        IF LEN(INTLAC) EQ 0 THEN
            TXTVAR1=TXTVAR1:"":INTLAC:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTLAC:" ":"Lac"
        END

        IF LEN(INTTHOUSAND) EQ 0 THEN
            TXTVAR1=TXTVAR1:"":INTTHOUSAND:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTTHOUSAND:" ":"Thousand"
        END

        IF LEN(INTHUNDRED) EQ 0 THEN
            TXTVAR1=TXTVAR1:"":INTHUNDRED:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTHUNDRED:" ":"Hundred"
        END

        TXTVAR1="Taka ":TXTVAR1:" ":INTREST
        IF LEN(INTDES) EQ 0 THEN
            TXTVAR1=TXTVAR1:""
        END
        ELSE
            TXTVAR1=TXTVAR1:" ":"and":" Paisa ":INTDES
        END
        TXTOUT = EREPLACE (TXTVAR1,"  "," ")

        IF T.CUR.AMT EQ 0 THEN
                
*            AF = TTV.T.AMT
            EB.SystemTables.setAf(EB.TT.83.T.AMT)
*            ETEXT = 'Total Amount should not be null.'
            EB.SystemTables.setEtext('Total Amount should not be null.')
* CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    
        ELSE
*--- This block is not required as it's already considered in GB.JBL.CR.TTV.CKID Routine--------------------------- *
*            R.NEW(TTV.T.F.UNIT) = F.UNIT
*            R.NEW(TTV.T.F.AMT) = F.AMT
*            R.NEW(TTV.T.M.UNIT) = M.UNIT
*            R.NEW(TTV.T.M.AMT) = M.AMT
*            R.NEW(TTV.T.N.UNIT) = N.UNIT
*            R.NEW(TTV.T.N.AMT) = N.AMT
*            R.NEW(TTV.T.COIN) = COIN
*            R.NEW(TTV.T.C.AMT) = C.AMT
*            R.NEW(TTV.T.UNIT) = T.CUR.UNIT
*            R.NEW(TTV.T.AMT) = T.CUR.AMT
*--- This block is not required  END --------------------------- *
            EB.SystemTables.setRNew(EB.TT.83.T.AMT.W, TXTOUT)
* R.NEW(EB.TT.83.T.AMT.W) = TXTOUT
        END
        RETURN
 
TTV.CHECK.BAL:
        FN.TTV = 'F.EB.JBL.TT.VAULT'
        F.TTV = ''

        EB.DataAccess.Opf(FN.TTV,F.TTV)

*        Y.TOT.AMT = R.NEW(TTV.T.AMT)
        Y.TOT.AMT = EB.SystemTables.getRNew(EB.TT.83.T.AMT)
*        Y.TDATE = ID.NEW[6,8]
        Y.TDATE = Y.ID.NEW[6,8]

        IF Y.TDATE EQ Y.TODAY THEN
            CALL NOFILE.DAYEND.CASH.MEMO.LOCAL(Y.CIH)
            FINDSTR 'Closing Balance' IN Y.CIH  SETTING  Y.POS THEN  END
            Y.CLOSE.AMT = FIELD(Y.CIH<Y.POS>,'Closing Balance',2)
            Y.CL.AMT = FIELD(Y.CLOSE.AMT,"*",2)
            Y.DIF.BAL = Y.CL.AMT - Y.TOT.AMT

            IF Y.TOT.AMT NE Y.CL.AMT THEN
* AF = TTV.T.AMT
                EB.SystemTables.setAf(EB.TT.83.T.AMT)
*                AV =1
                EB.SystemTables.setAv(1)
*                ETEXT= 'Your Closing Balance:':Y.CL.AMT:' Mismatch With Total Denomination Amount:':Y.TOT.AMT:' Differ Balance: ':Y.DIF.BAL
                EB.SystemTables.setEtext('Your Closing Balance:':Y.CL.AMT:' Mismatch With Total Denomination Amount:':Y.TOT.AMT:' Differ Balance: ':Y.DIF.BAL)
*                CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
            END
        END
        RETURN
    END
    
    
    
