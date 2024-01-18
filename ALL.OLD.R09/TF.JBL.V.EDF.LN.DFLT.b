SUBROUTINE TF.JBL.V.EDF.LN.DFLT
*-----------------------------------------------------------------------------
* Description : if you don't give  LT.AC.DR.PUR.RN, LT.AC.BD.EXLCNO this filed value in EDF Arrangement account property
*               this field will populate from EDF Interim.
*
* 12/14/2020 -                            Create by  - MAHMUDUR RAHMAN UDOY,
*                                                      FDS Bangladesh Limited
* Activity.Api: JBL.TF.EDF.API
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
     
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING AA.Framework
    $USING AA.Account
    $USING EB.API
    $USING EB.Updates
    $USING EB.Utility

    

   
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
INITIALISE:
    FN.ARR = 'F.AA.ARRANGEMENT'
    F.ARR = ''
    
    FN.ML = 'F.MNEMONIC.LETTER'
    F.ML  = ''
    
    Y.APP="AA.ARR.ACCOUNT"
    Y.FLDS="LT.AC.DR.PUR.RN":VM:"LT.AC.BD.EXLCNO":VM:"LT.TF.TERM":VM:"LT.AC.BD.LNMADT":VM:"LT.EDF.INTER.ID"
    Y.POS= ''
 
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLDS,Y.POS)
    Y.TF.REF.POS =Y.POS<1,1>
    Y.BB.LC.POS = Y.POS<1,2>
    Y.TERM.POS  = Y.POS<1,3>
    Y.LNMADT.POS = Y.POS<1,4>
    Y.EDF.INTER.ID.POS = Y.POS<1,5>
    
RETURN
   
OPENFILE:
    
    EB.DataAccess.Opf(FN.ARR, F.ARR)
    EB.DataAccess.Opf(FN.ML, F.ML)
   
RETURN
   
PROCESS:
  
    Y.AC.LOC.REF = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    ArrangementId = Y.AC.LOC.REF<1, Y.EDF.INTER.ID.POS>
    PROP.CLASS.TRM = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(ArrangementId,PROP.CLASS.TRM,'ACCOUNT','',RETURN.IDS.TRM,RETURN.VALUES.TRM,ERR.MSG.TRM)
    RETURN.VALUES.TRM = RAISE(RETURN.VALUES.TRM)
    Y.ACC.REF = RETURN.VALUES.TRM<AA.Account.Account.AcLocalRef>
    Y.OLD.TF.REF = Y.ACC.REF<1, Y.BB.LC.POS>
    Y.TF.NUM = Y.ACC.REF<1, Y.TF.REF.POS>
    

    Y.TEMP = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    Y.ARR.TF.NUM = Y.TEMP<1, Y.TF.REF.POS>
    Y.ARR.OLD.LC.NUM = Y.TEMP<1,Y.BB.LC.POS>
    IF Y.ARR.TF.NUM EQ '' THEN
        Y.TEMP<1,Y.TF.REF.POS> = Y.TF.NUM
    END
    IF Y.ARR.OLD.LC.NUM EQ '' THEN
        Y.TEMP<1,Y.BB.LC.POS> = Y.OLD.TF.REF
    END
*    IF Y.DATE NE '' THEN
*        Y.TEMP<1,Y.LNMADT.POS> = Y.DATE
*    END
    EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef, Y.TEMP)
       
       
RETURN
 

END
