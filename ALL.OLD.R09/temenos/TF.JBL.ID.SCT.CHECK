* @ValidationCode : MjotODY0MTUwNDg1OkNwMTI1MjoxNTYyMDEyNTQ4NTIwOkRFTEw6LTE6LTE6MDowOmZhbHNlOk4vQTpSMTdfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jul 2019 02:22:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.ID.SCT.CHECK
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History : Abu Huraira
* Attached to: BD.SCT.CAPTURE,CONT.AMEND
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess

*To restrict new id creation
    FN.BD.SCT.CAPTURE = 'F.BD.SCT.CAPTURE'
    F.BD.SCT.CAPTURE = ''
    EB.DataAccess.Opf(FN.BD.SCT.CAPTURE, F.BD.SCT.CAPTURE)
    EB.DataAccess.FRead(FN.BD.SCT.CAPTURE, EB.SystemTables.getComi(), REC.SCT.TEMP, F.BD.SCT.CAPTURE, ERR.SCT.TEMP)
    IF REC.SCT.TEMP EQ '' THEN
        EB.SystemTables.setE('NEW RECORD NOT POSSIBLE')
        RETURN
    END
RETURN
END
