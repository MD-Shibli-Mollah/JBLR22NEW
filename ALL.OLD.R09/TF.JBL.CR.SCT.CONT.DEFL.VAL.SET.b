* @ValidationCode : MjoxMTczMzA1ODQ3OkNwMTI1MjoxNTczNDcyMjkwMDI3OkRFTEw6LTE6LTE6MDowOmZhbHNlOk4vQTpSMTdfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Nov 2019 17:38:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.CR.SCT.CONT.DEFL.VAL.SET
*-----------------------------------------------------------------------------
*Subroutine Description: Add charge amount in payment of import acceptance payment
*Subroutine Type:
*Attached To    : BD.SCT.CAPTURE,CONT.RECORD
*Attached As    :CHECK RECORD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 30/03/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
   
    IF EB.SystemTables.getApplication() EQ 'BD.SCT.CAPTURE' THEN
        IF EB.SystemTables.getPgmVersion() EQ ',CONT.RECORD' THEN
*To restrict reverse entry
            IF EB.SystemTables.getVFunction() EQ 'R' THEN
                EB.SystemTables.setE('REVERSE NOT POSSIBLE')
                RETURN
            END
*To restrict History Restore
            IF EB.SystemTables.getVFunction() EQ 'H' THEN
                EB.SystemTables.setE('HISTORY RESTORE NOT POSSIBLE')
                RETURN
            END
*To restrict amendmend
            FN.BD.SCT.CAPTURE = 'F.BD.SCT.CAPTURE'
            F.BD.SCT.CAPTURE = ''
            EB.DataAccess.Opf(FN.BD.SCT.CAPTURE, F.BD.SCT.CAPTURE)
            EB.DataAccess.FRead(FN.BD.SCT.CAPTURE, EB.SystemTables.getIdNew(), REC.SCT.TEMP, F.BD.SCT.CAPTURE, ERR.SCT.TEMP)
            IF REC.SCT.TEMP NE '' THEN
                EB.SystemTables.setE('AMENDMEND NOT POSSIBLE')
                RETURN
            END
*To set default no input of job no
            Y.CUS.NO = EREPLACE(FIELD(EB.SystemTables.getIdNew(),'.',1),'SCT','')
            EB.SystemTables.setRNew(SCT.BENEFICIARY.CUSTNO, Y.CUS.NO)
            T(SCT.BTB.JOB.NO)<3>='NOINPUT'
        END ELSE
*During Contract amendmend to restrict reverse entry
            IF EB.SystemTables.getVFunction() EQ 'R' THEN
                TOT.REP.ELC = DCOUNT(EB.SystemTables.getRNew(SCT.REP.ELC.NO),VM)
                TOT.COLL.TF = DCOUNT(EB.SystemTables.getRNew(SCT.COLL.TF.ID),VM)
                IF (TOT.REP.ELC GE '1' OR TOT.COLL.TF GE '1') THEN
                    EB.SystemTables.setE('REVERSE NOT POSSIBLE REPLACEMENT OR COLLECTION IS OCCURED')
                    RETURN
                END
            END
        END
    END
    IF EB.SystemTables.getApplication() EQ 'LETTER.OF.CREDIT' THEN
*T(SCT.BTB.JOB.NO)<3>='NOINPUT'
    END
RETURN
END
