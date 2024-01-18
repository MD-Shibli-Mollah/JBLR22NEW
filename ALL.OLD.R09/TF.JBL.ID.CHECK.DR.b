SUBROUTINE TF.JBL.ID.CHECK.DR
*-----------------------------------------------------------------------------
*Subroutine Description: Checking for LC export or not
*Subroutine Type:
*Attached To    : DRAWINGS,JBL.EXPAC , DRAWINGS,JBL.EXREGDISC , DRAWINGS,JBL.F.CONDOCREAL , DRAWINGS,JBL.F.EXPCOLL ,    DRAWINGS,JBL.F.EXPDOCREAL ,
* DRAWINGS,JBL.F.PPMT.EXPDOCREAL   , DRAWINGS,JBL.I.CONDOCREAL , DRAWINGS,JBL.I.EXPCOLL , DRAWINGS,JBL.I.EXPDOCREAL , DRAWINGS,JBL.I.PPMT.EXPDOCREAL
* DRAWINGS,JBL.SALCSCOLL
*Attached As    : CHECK ID ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 16/04/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN
*                                                 FDS Pvt Ltd
*-----------------------------------------------------------------------------
    

    $INCLUDE  I_COMMON
    $INCLUDE  I_EQUATE
    $USING LC.Contract
    $USING LC.Config
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INIT; *INITIALISATION
    GOSUB PROCESS; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------
RETURN
 
*** <region name= INITIALISE>
INIT:
*** <desc>INITIALISATION </desc>
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    EB.DataAccess.Opf(FN.LC,F.LC)
    R.LC.REC = ''
    Y.LC.ERR = ''

    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    EB.DataAccess.Opf(FN.DR,F.DR)
    R.DR.REC = ''
    Y.DR.ERR = ''

    FN.LC.TYPES = 'F.LC.TYPES'
    F.LC.TYPES = ''
    EB.DataAccess.Opf(FN.LC.TYPES,F.LC.TYPES)
    R.LC.TYPES.REC = ''
    Y.LC.TYPES.ERR = ''

    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.DOC.TYPE",Y.DOCTYPE.POS)
    EB.LocalReferences.GetLocRef("LC.TYPES","LT.LCTP.LOC.FRG",Y.LCTYP.FL.POS)
    Y.DR.ID = ''
    Y.LC.ID = ''
    Y.LC.TYPES = ''
    Y.LC.CATEGORY = ''
    Y.LC.TYPE.LF = ''
    Y.LC.TYPE.EI = ''
    Y.DOC.TYPE = ''

RETURN

*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.DR.ID = EB.SystemTables.getComi()
    
    
    Y.APP.VER.NAME = EB.SystemTables.getApplication() : EB.SystemTables.getPgmVersion()
    
    
    Y.LC.ID = EB.SystemTables.getComi()[1,12]
    EB.DataAccess.FRead(FN.LC,Y.LC.ID,R.LC.REC,F.LC,Y.LC.ERR)
    IF Y.LC.ERR THEN RETURN
    Y.LC.TYPES = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLcType>
    Y.LC.CATEGORY = R.LC.REC<LC.Contract.LetterOfCredit.TfLcCategoryCode >
    EB.DataAccess.FRead(FN.LC.TYPES,Y.LC.TYPES,R.LC.TYPES.REC,F.LC.TYPES,Y.LC.TYPES.ERR)
    
    Y.LC.TYPE.LF = R.LC.TYPES.REC<LC.Config.Types.TypLocalRef,Y.LCTYP.FL.POS>
    Y.LC.TYPE.EI = R.LC.TYPES.REC<LC.Config.Types.TypImportExport>
    EB.DataAccess.FRead(FN.DR,Y.DR.ID,R.DR.REC,F.DR,Y.DR.ERR)
    Y.DOC.TYPE = R.DR.REC<LC.Contract.Drawings.TfDrLocalRef,Y.DOCTYPE.POS>
    

    BEGIN CASE
        CASE Y.APP.VER.NAME EQ 'DRAWINGS,JBL.IMPLODGE' OR Y.APP.VER.NAME EQ 'DRAWINGS,BD.IMPDISDOC' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.IMPAC' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.IMPSP' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.IMPMAT'
            GOSUB CHECK.IMP.DR.ID
        CASE Y.APP.VER.NAME EQ 'DRAWINGS,JBL.BTBLODGE' OR Y.APP.VER.NAME EQ 'DRAWINGS,BD.BTBDISCDOCS' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.BTBAC' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.BTBSP' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.BTBMAT'
            GOSUB CHECK.BTB.DR.ID
        CASE Y.APP.VER.NAME EQ 'DRAWINGS,BD.EXPCOLL' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.F.EXPCOLL' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.I.EXPCOLL' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.EXREGDISC' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.EXPAC' OR Y.APP.VER.NAME EQ 'DRAWINGS,BD.EXPDOCREAL' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.F.EXPDOCREAL' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.I.EXPDOCREAL' OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.SALCSCOLL'  OR  Y.APP.VER.NAME EQ 'DRAWINGS,JBL.F.CONDOCREAL'   OR Y.APP.VER.NAME EQ 'DRAWINGS,JBL.I.CONDOCREAL'
            GOSUB CHECK.EXP.DR.ID
    END CASE
RETURN
*
CHECK.BTB.DR.ID:
    IF Y.LC.CATEGORY LT '23240' OR Y.LC.CATEGORY GT '23305' THEN
        EB.SystemTables.setE("Not Back To Back LCs")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
*
CHECK.IMP.DR.ID:
    IF Y.LC.CATEGORY LT '23005' OR Y.LC.CATEGORY GT '23095' THEN
      
        EB.SystemTables.setE("Not Import LCs")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN

CHECK.EXP.DR.ID:
    IF Y.LC.TYPE.EI NE "E" THEN
        EB.SystemTables.setE("Not Export LC Document")
        EB.ErrorProcessing.StoreEndError()
    END
    IF (Y.APP.VER.NAME EQ "DRAWINGS,JBL.F.EXPCOLL" OR Y.APP.VER.NAME EQ "DRAWINGS,JBL.F.EXPDOCREAL") AND Y.LC.TYPE.LF NE "FOREIGN" THEN
        
        EB.SystemTables.setE("Not Foreign LC Document")
        EB.ErrorProcessing.StoreEndError()
    END
    IF (Y.APP.VER.NAME EQ "DRAWINGS,JBL.I.EXPCOLL" OR Y.APP.VER.NAME EQ "DRAWINGS,JBL.I.EXPDOCREAL") AND Y.LC.TYPE.LF NE "LOCAL" THEN
        EB.SystemTables.setE("Not Inland LC Document")
        EB.ErrorProcessing.StoreEndError()
    END
    IF Y.APP.VER.NAME EQ "DRAWINGS,JBL.SALCSCOLL" AND Y.LC.CATEGORY NE "23176" THEN
        EB.SystemTables.setE("Not Sales Contract Document")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN

END
