
SUBROUTINE GB.JBL.V.CONVT.AMT.WORD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*--------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*$INSERT I_F.FUNDS.TRANSFER
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.Foundation
    $USING TT.Contract
*-----------------------------------------------------------------------------
* Subroutine Description:
* This Routine Convert number to Text. This routine call CM.CALHUND Routine.
* Return value : "LNGVAR" is incoming parameter, and "TXTOUT" is outgoing paramete.

* Attach As: VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/05/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
* 06/06/2024 -                             UPDATE -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
* ADD Foreign Part
*
*-----------------------------------------------------------------------------
    AppName = EB.SystemTables.getApplication()
    IF AppName EQ 'FUNDS.TRANSFER' THEN
        LNGVAR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        Y.CURRENCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCurrency)
        
        IF LNGVAR EQ "" OR LNGVAR EQ 0 THEN
            LNGVAR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
            Y.CURRENCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditCurrency)
        END
    END
    
    IF AppName EQ 'TELLER' THEN
        LNGVAR = EB.SystemTables.getRNew(TT.Contract.Teller.TeNetAmount)
        Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
        IF Y.CURRENCY NE "BDT" THEN
            Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyTwo)
        END
        
        IF LNGVAR EQ "" OR LNGVAR EQ 0 THEN
            LNGVAR = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
            Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
        END
        
        IF LNGVAR EQ "" OR LNGVAR EQ 0 THEN
            LNGVAR = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalTwo)
            Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyTwo)
        END
    END
    
    TXTOUT = ''
    TXTVAR1 = ''
    INTVAL = ''
    Y.COMI.LEN = LEN(LNGVAR)
    IF Y.COMI.LEN LT 20 THEN
        
        INTVAL = FIELD(LNGVAR,'.',1)
        INTVAL3 = FIELD(LNGVAR,'.',2)

        IF INTVAL3 NE 0 THEN
            INTVAL2=INTVAL3
        END ELSE
            INTVAL2=0
        END

        CORE=INT(INTVAL / 10000000)
        CALL CM.CALHUND(CORE,INTCORE)
        INTVAL = INT(INTVAL - INT(INTVAL / 10000000) * 10000000)

        LAC=INT(INTVAL / 100000)
        CALL CM.CALHUND(LAC,INTLAC)
        INTVAL = INT(INTVAL - INT(INTVAL / 100000) * 100000)

        THOUSAND=INT(INTVAL / 1000)
        CALL CM.CALHUND(THOUSAND,INTTHOUSAND)
        INTVAL = INT(INTVAL - INT(INTVAL / 1000) * 1000)

        HUNDRED=INT(INTVAL / 100)
        CALL CM.CALHUND(HUNDRED,INTHUNDRED)
        INTVAL = INT(INTVAL - INT(INTVAL / 100) * 100)

        REST=INT(INTVAL / 1)
        CALL CM.CALHUND(REST,INTREST)

        DES=INT(INTVAL2 / 1)
        CALL CM.CALHUND(DES,INTDES)

        IF LEN(INTCORE) EQ 0 THEN
            TXTVAR1=INTCORE:" ":""
        END ELSE
            TXTVAR1=INTCORE:" ":"Crore"
        END

        IF LEN(INTLAC) EQ 0 THEN
            TXTVAR1=TXTVAR1:" ":INTLAC:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTLAC:" ":"Lac"
        END

        IF LEN(INTTHOUSAND) EQ 0 THEN
            TXTVAR1=TXTVAR1:" ":INTTHOUSAND:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTTHOUSAND:" ":"Thousand"
        END

        IF LEN(INTHUNDRED) EQ 0 THEN
            TXTVAR1=TXTVAR1:" ":INTHUNDRED:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTHUNDRED:" ":"Hundred"
        END

*----- CASE need to apply for different types of Currency -----*
        BEGIN CASE
    
            CASE Y.CURRENCY EQ 'BDT'
                TXTVAR1=TXTVAR1:" ":INTREST:" ":"Taka"
                IF LEN(INTDES) EQ 0 THEN
                END
                ELSE
                    TXTVAR1=TXTVAR1:" ":"and":" ":INTDES:" ":"Paisa"
                END
    
            CASE Y.CURRENCY EQ 'USD'
                TXTVAR1=TXTVAR1:" ":INTREST:" ":"Dollar"
                IF LEN(INTDES) EQ 0 THEN
                END
                ELSE
                    TXTVAR1=TXTVAR1:" ":"and":" ":INTDES:" ":"Cent"
                END
    
            CASE Y.CURRENCY EQ 'GBP'
                TXTVAR1=TXTVAR1:" ":INTREST:" ":"Pound"
                IF LEN(INTDES) EQ 0 THEN
                END
                ELSE
                    TXTVAR1=TXTVAR1:" ":"and":" ":INTDES:" ":"Penny"
                END
    
            CASE Y.CURRENCY EQ 'JPY'
                TXTVAR1=TXTVAR1:" ":INTREST:" ":"Yen"
                IF LEN(INTDES) EQ 0 THEN
                END
                ELSE
                    TXTVAR1=TXTVAR1:" ":"and":" ":INTDES:" ":"Sen"
                END
            
            CASE Y.CURRENCY EQ 'EUR'
                TXTVAR1=TXTVAR1:" ":INTREST:" ":"Euro"
                IF LEN(INTDES) EQ 0 THEN
                END
                ELSE
                    TXTVAR1=TXTVAR1:" ":"and":" ":INTDES:" ":"Euro cent"
                END
        END CASE
        
        TXTOUT = TXTVAR1
        IF AppName EQ 'FUNDS.TRANSFER' THEN
            APPLICATION.NAMES = 'FUNDS.TRANSFER'
            LOCAL.FIELDS = 'LT.AMT.WORD'
            EB.Foundation.MapLocalFields(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
        
            getLocalFieldData = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
            getLocalFieldData<1,FLD.POS> = TXTOUT
        
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,getLocalFieldData)
        END
    
        IF AppName EQ 'TELLER' THEN
            APPLICATION.NAMES = 'TELLER'
            LOCAL.FIELDS = 'LT.AMT.WORD'
            EB.Foundation.MapLocalFields(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
            
            getLocalFieldData = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
            getLocalFieldData<1,FLD.POS> = TXTOUT
        
            EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,getLocalFieldData)
        END
    
    END
RETURN

END
