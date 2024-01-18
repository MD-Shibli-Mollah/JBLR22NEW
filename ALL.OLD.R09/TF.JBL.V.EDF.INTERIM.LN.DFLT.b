SUBROUTINE TF.JBL.V.EDF.INTERIM.LN.DFLT
*-----------------------------------------------------------------------------
* Description : IF TF number not given to account property LT.AC.DR.PUR.RN filed this routine give the
*               value from MNEMONIC.LETTER application with Account property LT.AC.BD.EXLCNO field number.
*
* 10/05/2020 -                            Create by - MAHMUDUR RAHMAN UDOY,
*                                                     FDS Bangladesh Limited
* Activity.Api: JBL.TF.EDF.INTER.API,  JBL.TF.PAD.CASH.API & JBL.TF.IDBP.API
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
    FN.ML = 'F.MNEMONIC.LETTER'
    F.ML  = ''
    
    Y.APP="AA.ARR.ACCOUNT"
    Y.FLDS="LT.AC.DR.PUR.RN":VM:"LT.AC.BD.EXLCNO":VM:"LT.TF.TERM"
    Y.POS= ''
 
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLDS,Y.POS)
    Y.TF.REF.POS =Y.POS<1,1>
    Y.BB.LC.POS = Y.POS<1,2>
    Y.TERM.POS  = Y.POS<1,3>
    
    
RETURN
   
OPENFILE:
    
    EB.DataAccess.Opf(FN.ML, F.ML)
   
RETURN
   
PROCESS:

    Y.AC.LOC.REF = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    Y.OLD.TF.REF = Y.AC.LOC.REF<1, Y.BB.LC.POS>
 
    EB.DataAccess.FRead(FN.ML, Y.OLD.TF.REF, ML.REC, F.ML, ERR.REC)
    IF ML.REC THEN
        Y.TF.REF = ML.REC<1> ;* We can't find this Parchage record that's we read derect position following ss.
*	Y.TEMP = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
        Y.ARR.TF.NUM = Y.AC.LOC.REF<1, Y.TF.REF.POS>
        IF Y.TF.REF NE '' AND Y.ARR.TF.NUM EQ '' THEN
            Y.AC.LOC.REF<1,Y.TF.REF.POS> = Y.TF.REF
        END
    END
    EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef, Y.AC.LOC.REF)

        
RETURN
 
END

