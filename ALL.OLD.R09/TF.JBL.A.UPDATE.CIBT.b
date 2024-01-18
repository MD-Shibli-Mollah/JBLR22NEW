SUBROUTINE TF.JBL.A.UPDATE.CIBT
*-----------------------------------------------------------------------------
*Subroutine Description: CIBT data write in JBL.H.NM.ER from drawings
*Subroutine Type:
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.IMPSP, DRAWINGS,JBL.IMPSP.PPMT, DRAWINGS,JBL.IMPSP.T, DRAWINGS,JBL.IMPMAT,
* DRAWINGS,JBL.IMPMAT.PPMT, DRAWINGS,JBL.BTBMAT, DRAWINGS,JBL.BTBSP, DRAWINGS,JBL.BTBSP.T)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING FT.Contract
    $USING TT.Contract
    $USING DC.Contract
    
    $INSERT I_F.JBL.H.NM.ER
    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.ABL.H.NM.ER  ="F.JBL.H.NM.ER"
    F.ABL.H.NM.ER=""
*NM.BRANCH="NM.BRANCH"
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.ABL.H.NM.ER,F.ABL.H.NM.ER)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    BEGIN CASE
        CASE EB.SystemTables.getApplication() EQ "DRAWINGS"
            IF EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawingType) EQ 'SP' OR EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawingType) EQ 'MA' THEN
                Y.ID = EB.SystemTables.getIdNew()
                EB.LocalReferences.GetLocRef("DRAWINGS","BR.CODE",Y.BR.CODE.POS)
                REC.CIBIT<JBL.NM.BRANCH.CODE>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.BR.CODE.POS>

                REC.CIBIT<JBL.NM.VALUE.DATE>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrValueDate)

                EB.LocalReferences.GetLocRef("DRAWINGS","ENTRY.TYPE",Y.ENTRY.TYPE.POS)
                REC.CIBIT<JBL.NM.OE.RE>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.ENTRY.TYPE.POS>

                EB.LocalReferences.GetLocRef("DRAWINGS","CODE",Y.CODE.POS)
                REC.CIBIT<JBL.NM.TRANS.CODE>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.CODE.POS>

                EB.LocalReferences.GetLocRef("DRAWINGS","ADV.NO",Y.ADV.NO.POS)
                REC.CIBIT<JBL.NM.ADVICE.NO>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.ADV.NO.POS>

                EB.LocalReferences.GetLocRef("DRAWINGS","SUB.ADV.NO",Y.SUB.ADVNO.POS)
                REC.CIBIT<JBL.NM.SUB.ADVICE.NO>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.SUB.ADVNO.POS>

                EB.LocalReferences.GetLocRef("DRAWINGS","ADVICE.TYPE",Y.ADVICE.TYPE.POS)
                REC.CIBIT<JBL.NM.DR.CR.MARKER>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.ADVICE.TYPE.POS>

                EB.LocalReferences.GetLocRef("DRAWINGS","ACC.NO",Y.ACCNO.POS)
                REC.CIBIT<JBL.NM.ACCOUNT.NO>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.ACCNO.POS>

                EB.LocalReferences.GetLocRef("DRAWINGS","ADV.AMT",Y.ADVAMT.POS)
                REC.CIBIT<JBL.NM.AMOUNT>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.ADVAMT.POS>

                EB.LocalReferences.GetLocRef("DRAWINGS","REMARKS",Y.REMARKS.POS)
                REC.CIBIT<JBL.NM.REMARKS>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.REMARKS.POS>

                REC.CIBIT<JBL.NM.CO.CODE>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrCoCode)

                EB.DataAccess.FWrite(FN.ABL.H.NM.ER,Y.ID,REC.CIBIT)
            END
    END CASE
RETURN
*** </region>
END
