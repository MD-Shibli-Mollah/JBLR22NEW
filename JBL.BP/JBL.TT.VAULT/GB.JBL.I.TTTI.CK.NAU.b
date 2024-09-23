
SUBROUTINE GB.JBL.I.TTTI.CK.NAU

*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: EB.JBL.TT.TELLER.ID,INPUT , EB.JBL.TT.TELLER.ID,VAULT
* Attach As: INPUT ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from TTTI.CK.NAU
* 23/09/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
* IN.WORDS of R09 will be LT.AMT.WORD for LRT of TELLER
*
*--------------------------------------------------------------------------------
   
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.JBL.TT.TELLER.ID
    
    $USING TT.Contract
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING ST.CompanyCreation
    $USING EB.Security
*
    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.APPLICATION = EB.SystemTables.getApplication()
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.OPERATOR = EB.SystemTables.getOperator()
    
    IF Y.VFUNCTION EQ 'D' THEN RETURN

    FN.TTI = 'F.EB.JBL.TT.TELLER.ID'
    F.TTI = ''
    EB.DataAccess.Opf(FN.TTI,F.TTI)
    
    FN.TI = 'F.TELLER.ID'
    F.TI = ''
    EB.DataAccess.Opf(FN.TI,F.TI)

    IF FIELD(Y.ID.NEW,'.',1) EQ '9999' THEN
*        T(TTTI.COUNTER.LIMIT)<3> = "NOINPUT"
        EB.SystemTables.setT(EB.JBL91.COUNTER.LIMIT, "NOINPUT")
*        T(TTTI.DR.CR)<3> = "NOINPUT"
        EB.SystemTables.setT(EB.JBL91.DR.CR, "NOINPUT")
*        T(TTTI.LIMIT)<3> = "NOINPUT"
        EB.SystemTables.setT(EB.JBL91.LIMIT, "NOINPUT")
    END

    ELSE
* T(TTTI.SAFE.LIMIT)<3> = "NOINPUT"
        EB.SystemTables.setT(EB.JBL91.SAFE.LIMIT, "NOINPUT")
    END

    IF FIELD(Y.ID.NEW,'.',1) NE '9999' THEN
        Y.TTI.ID = '9999.':Y.ID.COMPANY[6,4]
        EB.DataAccess.FRead(FN.TTI, Y.TTI.ID, R.TTI, F.TTI, ERR.TTI)
        
        IF R.TTI EQ '' THEN
* AF = 0
            EB.SystemTables.setAf(0)
* ETEXT = 'Set Vault Limit Before Setting Teller Counter Limit.'
            EB.SystemTables.setEtext('Set Vault Limit Before Setting Teller Counter Limit.')
* CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

    Y.TELLER.ID = EB.SystemTables.getRNew(EB.JBL91.TELLER.ID)
    EB.DataAccess.FRead(FN.TI, Y.TELLER.ID, R.TI, F.TI, ERR.TI)
    Y.TID.CATEGORY = R.TI<TT.Contract.TellerId.TidCategory>
    Y.ID.NEW.1 = FIELD(Y.ID.NEW,'.',1)
    IF Y.TID.CATEGORY EQ '' AND Y.ID.NEW.1 NE '9999' THEN
        Y.TEXT = 'Category is not defind for the Teller ID.'
* R.NEW(TTTI.OVERRIDE) = TEXT
        EB.SystemTables.setRNew(EB.JBL91.OVERRIDE, Y.TEXT)
    END

*    Y.CCY = R.NEW(TTTI.CCY)
    Y.CCY = EB.SystemTables.getRNew(EB.JBL91.CCY)
*    Y.DR.CR = R.NEW(TTTI.DR.CR)
    Y.DR.CR = EB.SystemTables.getRNew(EB.JBL91.DR.CR)
*    Y.S.LIMIT = R.NEW(TTTI.SAFE.LIMIT)
    Y.S.LIMIT = EB.SystemTables.getRNew(EB.JBL91.SAFE.LIMIT)
*    Y.C.LIMIT = R.NEW(TTTI.COUNTER.LIMIT)
    Y.C.LIMIT = EB.SystemTables.getRNew(EB.JBL91.COUNTER.LIMIT)
    
    FOR II = 1 TO DCOUNT(Y.CCY, @VM)
        Y.CUR.S.LIMIT = FIELD(Y.S.LIMIT,@VM, II)
        Y.CUR.C.LIMIT = FIELD(Y.C.LIMIT,@VM, II)
        
        Y.ID.NEW.1 = FIELD(Y.ID.NEW,'.',1)
        IF Y.ID.NEW.1 EQ '9999' THEN
            IF Y.CUR.S.LIMIT EQ '' OR Y.CUR.S.LIMIT EQ 0 THEN
*                EB.SystemTables.setAf(EB.JBL91.SAFE.LIMIT
                EB.SystemTables.setAf(EB.JBL91.SAFE.LIMIT)
*                AV = I
                EB.SystemTables.setAv(II)
                EB.SystemTables.setEtext('Input missing.')
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    
        ELSE
            IF Y.CUR.C.LIMIT EQ '' OR Y.CUR.C.LIMIT EQ 0 THEN
*                EB.SystemTables.setAf(EB.JBL91.COUNTER.LIMIT
                EB.SystemTables.setAf(EB.JBL91.COUNTER.LIMIT)
                EB.SystemTables.setAv(II)
                EB.SystemTables.setEtext('Input missing.')
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        
            Y.SAFE.LIMIT = R.TTI<EB.JBL91.SAFE.LIMIT>
            IF Y.CUR.C.LIMIT GT Y.SAFE.LIMIT THEN
                EB.SystemTables.setAf(EB.JBL91.COUNTER.LIMIT)
                EB.SystemTables.setAv(II)
                EB.SystemTables.setEtext('Counter Limit can not more than Vault Save Limit.')
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
        Y.CUR.CCY = FIELD(Y.CCY, @VM, II)
        IF COUNT(Y.CCY,Y.CUR.CCY) GT 1 THEN
            EB.SystemTables.setAf(EB.JBL91.CCY)
            EB.SystemTables.setAv(II)
            EB.SystemTables.setEtext(Y.CUR.CCY:' Used multiple times.')
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
        Y.CUR.DR.CR = FIELD(Y.DR.CR, @VM, II)
        FOR JJ = 1 TO DCOUNT(Y.CUR.DR.CR, @SM)
            Y.DR.CR.CUR = FIELD(Y.CUR.DR.CR, @SM, JJ)
            IF COUNT(Y.CUR.DR.CR, Y.DR.CR.CUR) GT 1 THEN
                EB.SystemTables.setAf(EB.JBL91.DR.CR)
* AV = J
                EB.SystemTables.setAv(JJ)
                EB.SystemTables.setEtext(Y.CUR.DR.CR:' Used multiple times.')
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        NEXT JJ

        Y.VER.ID = Y.APPLICATION : Y.PGM.VERSION
        Y.WORD = ''
        Y.CUR.LIMIT = ''
        IF Y.VER.ID EQ 'EB.JBL.TT.TELLER.ID,INPUT' THEN
* Y.CUR.LIMIT = R.NEW(TTTI.COUNTER.LIMIT)<II>
            Y.COUNTER.LIMIT = EB.SystemTables.getRNew(EB.JBL91.COUNTER.LIMIT)
            Y.CUR.LIMIT = Y.COUNTER.LIMIT<II>
        END
        IF Y.VER.ID EQ 'EB.JBL.TT.TELLER.ID,VAULT' THEN
* Y.CUR.LIMIT = R.NEW(TTTI.SAFE.LIMIT)<II>
            Y.SAFE.LIMIT = EB.SystemTables.getRNew(EB.JBL91.SAFE.LIMIT)
            Y.CUR.LIMIT = Y.SAFE.LIMIT<II>
        END
        CALL CM.CALHUND(Y.CUR.LIMIT, Y.WORD)
* R.NEW(TTTI.IN.WORD) = Y.WORD
        EB.SystemTables.setRNew(EB.JBL91.IN.WORD, Y.WORD)
    NEXT II
RETURN
END


