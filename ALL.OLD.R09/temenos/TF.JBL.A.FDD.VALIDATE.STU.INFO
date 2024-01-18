SUBROUTINE TF.JBL.A.FDD.VALIDATE.STU.INFO
*-----------------------------------------------------------------------------
*Subroutine Description:This Routine validates the FDD/FTT transactions of the Funds Transfer module with the Student Application
*                       if the Funds Transfer is related to the Education Quota. Student Transaction will be updated
*                       from the fileds in FT.
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
     
    
    
    $INSERT I_F.BD.FT.STUDENTFILE
*    $INSERT I_F.BD.H.FT.REM.PURPOSE
    
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
    FN.STDFILE='F.BD.FT.STUDENTFILE'
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
        IF Y.RMT.PURPOSE EQ '1120' THEN
            R.STD.REC<FT.STF.FT.TXN.REF,Y.COUNT>=Y.ID
            R.STD.REC<FT.STF.REM.DATE,Y.COUNT>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitValueDate)
            R.STD.REC<FT.STF.REM.AMOUNT,Y.COUNT>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
            R.STD.REC<FT.STF.CURR.TYPE,Y.COUNT>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditCurrency)
            R.STD.REC<FT.STF.FDD.NUMBER,Y.COUNT>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitTheirRef)
            R.STD.REC<FT.STF.PURP.OF.TRAN,Y.COUNT>=Y.RMT.PURPOSE
        END
        IF  EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus) EQ 'RNAU' THEN
            R.STD.REC<FT.STF.FT.STATUS>="REVERSED ON ":EB.SystemTables.getToday():" ":Y.ID
        END
        EB.DataAccess.FWrite(FN.STDFILE,Y.CUS.ID,R.STD.REC)
    END
RETURN
*** </region>
END
