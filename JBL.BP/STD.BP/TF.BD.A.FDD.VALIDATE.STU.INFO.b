SUBROUTINE TF.BD.A.FDD.VALIDATE.STU.INFO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
     
    
    
    $INSERT I_F.EB.BD.TF.STUDENTFILE
*    $INSERT I_EB.JBL.H.FT.REM.PURPOSE

    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------
    
*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.STDFILE='F.EB.BD.TF.STUDENTFILE'
    F.STDFILE=''

    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.TF.PUR.REMIT",Y.REMITTANCE.PURPOSE)
    Y.RMT.PURPOSE=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.REMITTANCE.PURPOSE>
    Y.ID=EB.SystemTables.getIdNew()
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.TF.STUD.FLNO",Y.STU.FILE.NO)
    Y.CUS.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.STU.FILE.NO>
    
    Y.PPS.CODE=''
    R.RMT.PURPOSE=''
    Y.PURPOSE=''

    SEL.CMD=''
    SEL.LIST=''
    NO.OF.REC=0
    RET.CODE=''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.STDFILE,F.STDFILE)
RETURN
*** </region>
 
*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
* TO UPDATE THE STUDENT INFORMATION
************************************
    EB.DataAccess.FRead(FN.STDFILE,Y.CUS.ID,R.STD.REC,F.STDFILE,STDERR1)
    IF R.STD.REC THEN
        Y.COUNT = DCOUNT(R.STD.REC<FT.STF.REM.DATE>,@VM)+1
*IF Y.RMT.PURPOSE EQ '1120' THEN
        R.STD.REC<EB.JBL50.FT.TXN.REF,Y.COUNT>=Y.ID
        R.STD.REC<EB.JBL50.REM.DATE,Y.COUNT>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitValueDate)
        R.STD.REC<EB.JBL50.REM.AMOUNT,Y.COUNT>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
        R.STD.REC<EB.JBL50.CURR.TYPE,Y.COUNT>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditCurrency)
        R.STD.REC<EB.JBL50.FDD.NUMBER,Y.COUNT>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitTheirRef)
        R.STD.REC<EB.JBL50.PURP.OF.TRAN,Y.COUNT>=Y.RMT.PURPOSE
*END
        IF  EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus) EQ 'RNAU' THEN
            R.STD.REC<EB.JBL50.FT.STATUS>="REVERSED ON ":EB.SystemTables.getToday():" ":Y.ID
        END
        WRITE R.STD.REC ON F.STDFILE, Y.CUS.ID
    END
RETURN

END
