SUBROUTINE GB.JBL.CR.LOCKING.WRITE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
    $USING ST.CompanyCreation
    $USING FT.Contract
    $USING TT.Contract
    $USING ST.Config
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
  
* IF cTxn_TransactionLevel LT 99 AND OFS$OPERATION EQ 'BUILD' THEN
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
*  END
RETURN


INIT:
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''

    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU = ''

    FN.TT = 'F.TELLER'
    F.TT = ''

    FN.TT.NAU = 'F.TELLER$NAU'
    F.TT.NAU = ''

    FN.CAT = 'F.CATEGORY'
    F.CAT = ''


    FN.LOC = 'F.LOCKING'
    F.LOC = ''

    Y.FT.ORGADJ.POS = ''
    Y.FT.AL.POS = ''
    Y.TT.ORGADJ.POS = ''
    Y.TT.AL.POS = ''
    Y.CAT.AL.POS = ''


    Y.TODAY = EB.SystemTables.getToday()
    Y.YEAR = Y.TODAY[3,2]
    
    Y.APP = EB.SystemTables.getApplication()
    Y.VERSION = EB.SystemTables.getPgmVersion()
    Y.APP.VER.NAME = Y.APP : Y.VERSION
    
    Y.SYS.LOCK = EB.SystemTables.getFLocking()
    
RETURN

OPENFILES:

    EB.DataAccess.Opf(FN.FT,F.FT)
    EB.DataAccess.Opf(FN.FT.NAU,F.FT.NAU)
    EB.DataAccess.Opf(FN.TT,F.TT)
    EB.DataAccess.Opf(FN.TT.NAU,F.TT.NAU)
    EB.DataAccess.Opf(FN.CAT,F.CAT)

    OPEN 'F.LOCKING' TO F.LOCKING ELSE F.LOCKING = ''
RETURN

PROCESS:
    
    
    Y.ID = EB.SystemTables.getIdNew()

    IF Y.APP EQ "FUNDS.TRANSFER" THEN
        EB.DataAccess.FRead(FN.FT.NAU,Y.ID,FT.NAU.REC,F.FT.NAU,FT.NAU.ERR)
    END

    IF Y.APP EQ "TELLER" THEN
        EB.DataAccess.FRead(FN.TT.NAU,Y.ID,TT.NAU.REC,F.TT.NAU,TT.NAU.ERR)
    END

    IF FT.NAU.REC OR TT.NAU.REC THEN

    END ELSE

        Y.LOCKING.ID = 'SS' : Y.TODAY
        READU R.LOCK.REC.CNT FROM Y.SYS.LOCK,Y.LOCKING.ID THEN
            R.LOCK.REC.CNT<1> += 1
        END ELSE
            R.LOCK.REC.CNT<1> = 1
        END

        Y.SERIAL.NO1 = R.LOCK.REC.CNT<1> + 0
        Y.SERIAL.NO1 = FMT(Y.SERIAL.NO1,'R%5')
        Y.LEN.NUM = LEN(Y.SERIAL.NO1)
        WRITE R.LOCK.REC.CNT TO Y.SYS.LOCK,Y.LOCKING.ID

        BEGIN CASE
            CASE Y.LEN.NUM EQ 1
                Y.SERIAL.NO = "0000":Y.SERIAL.NO1
            CASE Y.LEN.NUM EQ 2
                Y.SERIAL.NO = "000":Y.SERIAL.NO1
            CASE Y.LEN.NUM EQ 3
                Y.SERIAL.NO = "00":Y.SERIAL.NO1
            CASE Y.LEN.NUM EQ 4
                Y.SERIAL.NO = "0":Y.SERIAL.NO1
            CASE Y.LEN.NUM EQ 5
                Y.SERIAL.NO = Y.SERIAL.NO1
        END CASE

        Y.REF.ID = 'SS' : Y.TODAY : Y.SERIAL.NO

        IF Y.VERSION EQ ",MBL.SUSP.ORG" THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitTheirRef, Y.REF.ID)
        END
    
        IF Y.VERSION EQ ",JBL.SUSP.ORG" THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitTheirRef, Y.REF.ID)
        END

        IF Y.VERSION EQ ",MBL.SUNDRY.ORG" THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditTheirRef, Y.REF.ID)
        END
        IF Y.VERSION EQ ",JBL.SUNDRY.ORG" THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditTheirRef, Y.REF.ID)
        END
        IF Y.VERSION EQ ",JBL.SUND.ORG" THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditTheirRef, Y.REF.ID)
        END

        IF Y.VERSION EQ ",MBL.SDSA.LCY.CASHIN" OR Y.VERSION EQ ",MBL.SDSA.LCY.CASHWDL.SUSP" THEN
            EB.SystemTables.setRNew(TT.Contract.Teller.TeOurReference, Y.REF.ID)
        END
        IF Y.VERSION EQ ",JBL.SDSA.LCY.CASHIN" OR Y.VERSION EQ ",JBL.SDSA.LCY.CASHWDL.SUSP" THEN
            EB.SystemTables.setRNew(TT.Contract.Teller.TeOurReference, Y.REF.ID)
        END
    END

RETURN

END
