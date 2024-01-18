SUBROUTINE TF.JBL.E.CNV.TTFT.NARRATION
*-----------------------------------------------------------------------------
*Subroutine Description: for FT TT Narration
*Subroutine Type:
*Attached To    : BD.CATEG.ENT.BOOK
*Attached As    : CONVERSION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 17/09/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Reports
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING FT.Contract
    $USING TT.Contract
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.TT ='F.TELLER'
    F.TT =''

    FN.TTH ='F.TELLER$HIS'
    F.TTH =''

    FN.FT ='F.FUNDS.TRANSFER'
    F.FT =''

    FN.FTH ='F.FUNDS.TRANSFER$HIS'
    F.FTH =''

    Y.INP = ''
    Y.IN.SGN.NAME = ''
    R.INP.REC = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.TT, F.TT)
    EB.DataAccess.Opf(FN.TTH, F.TTH)
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.FTH, F.FTH)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.INP = EB.Reports.getOData()
    Y.FLAG = Y.INP[1,2]

    IF Y.FLAG EQ 'TT' THEN

       
        EB.DataAccess.FRead(FN.TT,Y.INP,R.INP.REC,F.TT,TT.ERR)
        IF R.INP.REC THEN
            Y.REF=R.INP.REC<TT.Contract.Teller.TeNarrativeTwo>
            EB.Reports.setOData(Y.REF)
        END
        ELSE
            
            EB.DataAccess.ReadHistoryRec(F.TTH,Y.INP,R.INP.REC,TTH.ERR)
            Y.REF=R.INP.REC<TT.Contract.Teller.TeNarrativeTwo>
            EB.Reports.setOData(Y.REF)
        END
    END
    ELSE IF Y.FLAG EQ 'FT' THEN

        
        EB.DataAccess.FRead(FN.FT,Y.INP,R.INP.REC,F.FT,FT.ERR)
        IF R.INP.REC THEN
            
            IF R.INP.REC<FT.Contract.FundsTransfer.DebitAcctNo>[1,2] EQ 'PL' THEN
                EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.FT.DR.NARR",Y.DR.NARR.POS)
                Y.DR.NARR = R.INP.REC<FT.Contract.FundsTransfer.LocalRef,Y.DR.NARR.POS>
                Y.REF=R.INP.REC<FT.Contract.FundsTransfer.PaymentDetails>:Y.DR.NARR
                Y.REF=R.INP.REC<FT.Contract.FundsTransfer.DebitTheirRef>:Y.REF
                EB.Reports.setOData(Y.REF)
            END
            ELSE
                EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.FT.CR.NARR",Y.CR.NARR.POS)
                Y.CR.NARR = R.INP.REC<FT.Contract.FundsTransfer.LocalRef,Y.CR.NARR.POS>
                Y.REF=R.INP.REC<FT.Contract.FundsTransfer.PaymentDetails>:Y.CR.NARR
                Y.REF=R.INP.REC<FT.Contract.FundsTransfer.CreditTheirRef>:Y.REF
                EB.Reports.setOData(Y.REF)
            END
        END
        ELSE
            EB.DataAccess.ReadHistoryRec(F.FTH,Y.INP,R.INP.REC,FT.ERR)

            IF R.INP.REC<FT.Contract.FundsTransfer.DebitAcctNo>[1,2] EQ 'PL' THEN
                EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.FT.DR.NARR",Y.DR.NARR.POS)
                Y.DR.NARR = R.INP.REC<FT.Contract.FundsTransfer.LocalRef,Y.DR.NARR.POS>
                Y.REF=R.INP.REC<FT.Contract.FundsTransfer.PaymentDetails>:Y.DR.NARR
                Y.REF=R.INP.REC<FT.Contract.FundsTransfer.DebitTheirRef>:Y.REF
                EB.Reports.setOData(Y.REF)
            END

            ELSE
                EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.FT.CR.NARR",Y.CR.NARR.POS)
                Y.CR.NARR = R.INP.REC<FT.Contract.FundsTransfer.LocalRef,Y.CR.NARR.POS>
                Y.REF=R.INP.REC<FT.Contract.FundsTransfer.PaymentDetails>:Y.CR.NARR
                Y.REF=R.INP.REC<FT.Contract.FundsTransfer.CreditTheirRef>:Y.REF
                EB.Reports.setOData(Y.REF)
            END
        END
 
        RETURN
*** </region>
    END
